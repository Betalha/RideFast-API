# Guia de Sintaxe - Phoenix API REST

Este guia contem toda a sintaxe necessaria para criar uma API REST com Phoenix, Ecto, Guardian (JWT) e BCrypt.

---

## 1. ESTRUTURA DO PROJETO

```
meu_projeto/
├── config/
│   ├── config.exs          # Configuracoes gerais
│   ├── dev.exs             # Config desenvolvimento
│   └── prod.exs            # Config producao
├── lib/
│   ├── meu_projeto/        # Logica de negocio (contexts)
│   │   ├── entidades/      # Schemas
│   │   ├── auth/           # Guardian
│   │   └── repo.ex         # Repositorio
│   └── meu_projeto_web/    # Camada web
│       ├── controllers/    # Controllers
│       ├── plugs/          # Middlewares
│       └── router.ex       # Rotas
├── priv/
│   └── repo/migrations/    # Migrations
└── mix.exs                 # Dependencias
```

---

## 2. MIX.EXS (Dependencias)

```elixir
defmodule MeuProjeto.MixProject do
  use Mix.Project

  def project do
    [
      app: :meu_projeto,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MeuProjeto.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.8.1"},
      {:phoenix_ecto, "~> 4.5"},
      {:ecto_sql, "~> 3.13"},
      {:myxql, ">= 0.0.0"},              # MySQL
      {:jason, "~> 1.4"},                 # JSON
      {:bandit, "~> 1.5"},                # HTTP Server
      {:bcrypt_elixir, "~> 3.0"},         # BCrypt
      {:guardian, "~> 2.0"}               # JWT
    ]
  end
end
```

---

## 3. CONFIGURACAO (config/config.exs)

```elixir
import Config

# Configuracao do Repo
config :meu_projeto,
  ecto_repos: [MeuProjeto.Repo]

# Configuracao do Endpoint
config :meu_projeto, MeuProjetoWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: MeuProjetoWeb.ErrorJSON],
    layout: false
  ]

# Configuracao do Guardian (JWT)
config :meu_projeto, MeuProjeto.Auth.Guardian,
  issuer: "meu_projeto",
  secret_key: "CHAVE_SECRETA_AQUI_BASE64"

# Jason como biblioteca JSON
config :phoenix, :json_library, Jason
```

### config/dev.exs (Banco de Dados)

```elixir
import Config

config :meu_projeto, MeuProjeto.Repo,
  username: "root",
  password: "senha",
  hostname: "localhost",
  database: "meu_banco_dev",
  port: 3306

config :meu_projeto, MeuProjetoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000]
```

---

## 4. MIGRATIONS

### Criar Migration

```bash
mix ecto.gen.migration create_produtos
```

### Sintaxe da Migration

```elixir
defmodule MeuProjeto.Repo.Migrations.CreateProdutos do
  use Ecto.Migration

  def change do
    # Criar tabela
    create table(:produtos) do
      add :nome, :string
      add :preco, :decimal
      add :ativo, :boolean, default: true
      add :descricao, :text
      add :quantidade, :integer
      add :data_criacao, :naive_datetime

      # Foreign key
      add :categoria_id, references(:categorias, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    # Criar indice
    create index(:produtos, [:categoria_id])
    create unique_index(:produtos, [:nome])
  end
end
```

### Migration para Tabela N:N (sem timestamps)

```elixir
defmodule MeuProjeto.Repo.Migrations.CreateProdutosTags do
  use Ecto.Migration

  def change do
    create table(:produtos_tags, primary_key: false) do
      add :produto_id, references(:produtos, on_delete: :delete_all), primary_key: true
      add :tag_id, references(:tags, on_delete: :delete_all), primary_key: true
    end

    create index(:produtos_tags, [:produto_id])
    create index(:produtos_tags, [:tag_id])
  end
end
```

### Executar Migrations

```bash
mix ecto.create    # Criar banco
mix ecto.migrate   # Rodar migrations
mix ecto.rollback  # Desfazer ultima migration
```

---

## 5. SCHEMAS (Modelos)

### Schema Basico

```elixir
defmodule MeuProjeto.Produtos.Produto do
  use Ecto.Schema
  import Ecto.Changeset

  # Permite serializar para JSON automaticamente
  @derive {Jason.Encoder, only: [:id, :nome, :preco, :ativo]}

  schema "produtos" do
    field :nome, :string
    field :preco, :decimal
    field :ativo, :boolean, default: true
    field :descricao, :text

    # Relacionamentos
    belongs_to :categoria, MeuProjeto.Categorias.Categoria
    has_many :pedidos, MeuProjeto.Pedidos.Pedido

    timestamps(type: :utc_datetime)
  end

  def changeset(produto, attrs) do
    produto
    |> cast(attrs, [:nome, :preco, :ativo, :descricao, :categoria_id])
    |> validate_required([:nome, :preco])
    |> validate_number(:preco, greater_than: 0)
    |> validate_length(:nome, min: 3, max: 100)
    |> unique_constraint(:nome)
    |> foreign_key_constraint(:categoria_id)
  end
end
```

### Schema com Password (BCrypt)

```elixir
defmodule MeuProjeto.Contas.Usuario do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :nome, :email]}

  schema "usuarios" do
    field :nome, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true  # Campo virtual - nao salva no banco

    timestamps(type: :utc_datetime)
  end

  # Changeset para criar (password obrigatorio)
  def changeset(usuario, attrs) do
    usuario
    |> cast(attrs, [:nome, :email, :password])
    |> validate_required([:nome, :email, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "email invalido")
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  # Changeset para update (password opcional)
  def update_changeset(usuario, attrs) do
    usuario
    |> cast(attrs, [:nome, :email, :password])
    |> validate_required([:nome, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  # Funcao privada para hash da senha
  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
```

### Schema N:N (Tabela de Juncao)

```elixir
defmodule MeuProjeto.ProdutosTags.ProdutoTag do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false  # Tabela sem id proprio

  schema "produtos_tags" do
    field :produto_id, :integer, primary_key: true
    field :tag_id, :integer, primary_key: true
    # Se coluna tem nome diferente no banco:
    # field :tag_id, :integer, source: :tag_identifier, primary_key: true
  end

  def changeset(produto_tag, attrs) do
    produto_tag
    |> cast(attrs, [:produto_id, :tag_id])
    |> validate_required([:produto_id, :tag_id])
    |> unique_constraint([:produto_id, :tag_id])
  end
end
```

---

## 6. CONTEXTS (Logica de Negocio)

```elixir
defmodule MeuProjeto.Produtos do
  import Ecto.Query, warn: false
  alias MeuProjeto.Repo
  alias MeuProjeto.Produtos.Produto

  # Listar todos
  def list_produtos do
    Repo.all(Produto)
  end

  # Listar com filtros
  def list_produtos(filtros) do
    Produto
    |> apply_filtros(filtros)
    |> Repo.all()
  end

  defp apply_filtros(query, filtros) do
    Enum.reduce(filtros, query, fn
      {"ativo", valor}, query -> where(query, [p], p.ativo == ^valor)
      {"categoria_id", id}, query -> where(query, [p], p.categoria_id == ^id)
      _, query -> query
    end)
  end

  # Buscar por ID (retorna nil se nao encontrar)
  def get_produto(id) do
    Repo.get(Produto, id)
  end

  # Buscar por ID (levanta erro se nao encontrar)
  def get_produto!(id) do
    Repo.get!(Produto, id)
  end

  # Buscar por campo
  def get_produto_by_nome(nome) do
    Repo.get_by(Produto, nome: nome)
  end

  # Criar
  def create_produto(attrs) do
    %Produto{}
    |> Produto.changeset(attrs)
    |> Repo.insert()
  end

  # Atualizar
  def update_produto(%Produto{} = produto, attrs) do
    produto
    |> Produto.changeset(attrs)
    |> Repo.update()
  end

  # Deletar
  def delete_produto(%Produto{} = produto) do
    Repo.delete(produto)
  end
end
```

### Context com Maquina de Estados

```elixir
defmodule MeuProjeto.Pedidos do
  import Ecto.Query, warn: false
  alias MeuProjeto.Repo
  alias MeuProjeto.Pedidos.Pedido

  # Estados: PENDENTE -> CONFIRMADO -> EM_PREPARO -> ENTREGUE
  #              |           |             |
  #              v           v             v
  #          CANCELADO    CANCELADO    CANCELADO

  def confirmar_pedido(%Pedido{} = pedido) do
    if pedido.status == "PENDENTE" do
      pedido
      |> Pedido.changeset(%{status: "CONFIRMADO"})
      |> Repo.update()
    else
      {:error, :status_invalido}
    end
  end

  def preparar_pedido(%Pedido{} = pedido) do
    if pedido.status == "CONFIRMADO" do
      pedido
      |> Pedido.changeset(%{status: "EM_PREPARO", inicio_preparo: NaiveDateTime.utc_now()})
      |> Repo.update()
    else
      {:error, :status_invalido}
    end
  end

  def entregar_pedido(%Pedido{} = pedido) do
    if pedido.status == "EM_PREPARO" do
      pedido
      |> Pedido.changeset(%{status: "ENTREGUE", data_entrega: NaiveDateTime.utc_now()})
      |> Repo.update()
    else
      {:error, :status_invalido}
    end
  end

  def cancelar_pedido(%Pedido{} = pedido) do
    if pedido.status in ["PENDENTE", "CONFIRMADO", "EM_PREPARO"] do
      pedido
      |> Pedido.changeset(%{status: "CANCELADO"})
      |> Repo.update()
    else
      {:error, :status_invalido}
    end
  end
end
```

---

## 7. GUARDIAN (JWT)

### Modulo Guardian

```elixir
# lib/meu_projeto/auth/guardian.ex
defmodule MeuProjeto.Auth.Guardian do
  use Guardian, otp_app: :meu_projeto

  alias MeuProjeto.Contas

  # Gera o "subject" do token (identifica o recurso)
  def subject_for_token({:usuario, usuario}, _claims) do
    {:ok, "usuario:#{usuario.id}"}
  end

  def subject_for_token({:admin, admin}, _claims) do
    {:ok, "admin:#{admin.id}"}
  end

  def subject_for_token(_, _) do
    {:error, :tipo_invalido}
  end

  # Recupera o recurso a partir do token
  def resource_from_claims(claims) do
    case claims["sub"] do
      "usuario:" <> id ->
        case Contas.get_usuario(id) do
          nil -> {:error, :nao_encontrado}
          usuario -> {:ok, {:usuario, usuario}}
        end

      "admin:" <> id ->
        case Contas.get_admin(id) do
          nil -> {:error, :nao_encontrado}
          admin -> {:ok, {:admin, admin}}
        end

      _ ->
        {:error, :subject_invalido}
    end
  end
end
```

### Pipeline de Autenticacao

```elixir
# lib/meu_projeto_web/plugs/auth_pipeline.ex
defmodule MeuProjetoWeb.Plugs.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :meu_projeto,
    module: MeuProjeto.Auth.Guardian,
    error_handler: MeuProjetoWeb.Plugs.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
end
```

### Error Handler

```elixir
# lib/meu_projeto_web/plugs/auth_error_handler.ex
defmodule MeuProjetoWeb.Plugs.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {tipo, _reason}, _opts) do
    mensagem = case tipo do
      :unauthenticated -> "Token ausente ou invalido"
      :unauthorized -> "Acesso nao autorizado"
      _ -> "Erro de autenticacao"
    end

    conn
    |> put_status(401)
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: mensagem}))
    |> halt()
  end
end
```

### Gerar e Validar Token

```elixir
# No controller de autenticacao:

# Gerar token
{:ok, token, _claims} = MeuProjeto.Auth.Guardian.encode_and_sign({:usuario, usuario})

# Validar senha com BCrypt
Bcrypt.verify_pass(senha_digitada, usuario.password_hash)  # retorna true/false
```

---

## 8. ROUTER

```elixir
defmodule MeuProjetoWeb.Router do
  use MeuProjetoWeb, :router

  # Pipeline para API JSON
  pipeline :api do
    plug :accepts, ["json"]
  end

  # Pipeline de autenticacao
  pipeline :auth do
    plug MeuProjetoWeb.Plugs.AuthPipeline
  end

  # Rotas publicas (sem autenticacao)
  scope "/api/v1", MeuProjetoWeb do
    pipe_through :api

    post "/auth/registrar", AuthController, :registrar
    post "/auth/login", AuthController, :login
    get "/produtos", ProdutoController, :index
  end

  # Rotas protegidas (com autenticacao)
  scope "/api/v1", MeuProjetoWeb do
    pipe_through [:api, :auth]

    # CRUD basico
    get "/usuarios", UsuarioController, :index
    get "/usuarios/:id", UsuarioController, :show
    post "/usuarios", UsuarioController, :create
    put "/usuarios/:id", UsuarioController, :update
    delete "/usuarios/:id", UsuarioController, :delete

    # Rotas aninhadas
    get "/categorias/:categoria_id/produtos", ProdutoController, :index
    post "/categorias/:categoria_id/produtos", ProdutoController, :create

    # Acoes customizadas
    post "/pedidos/:id/confirmar", PedidoController, :confirmar
    post "/pedidos/:id/cancelar", PedidoController, :cancelar
  end
end
```

---

## 9. CONTROLLERS

### Controller CRUD Completo

```elixir
defmodule MeuProjetoWeb.ProdutoController do
  use MeuProjetoWeb, :controller

  alias MeuProjeto.Produtos

  # GET /produtos
  def index(conn, params) do
    produtos = Produtos.list_produtos(params)
    json(conn, %{data: produtos})
  end

  # GET /produtos/:id
  def show(conn, %{"id" => id}) do
    case Produtos.get_produto(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Produto nao encontrado"})

      produto ->
        json(conn, %{data: produto})
    end
  end

  # POST /produtos
  def create(conn, params) do
    case Produtos.create_produto(params) do
      {:ok, produto} ->
        conn
        |> put_status(:created)
        |> json(%{data: produto})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  # PUT /produtos/:id
  def update(conn, %{"id" => id} = params) do
    case Produtos.get_produto(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Produto nao encontrado"})

      produto ->
        case Produtos.update_produto(produto, params) do
          {:ok, produto_atualizado} ->
            json(conn, %{data: produto_atualizado})

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(%{errors: changeset_errors(changeset)})
        end
    end
  end

  # DELETE /produtos/:id
  def delete(conn, %{"id" => id}) do
    case Produtos.get_produto(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Produto nao encontrado"})

      produto ->
        Produtos.delete_produto(produto)
        send_resp(conn, :no_content, "")
    end
  end

  # Funcao auxiliar para extrair erros do changeset
  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
```

### Controller de Autenticacao

```elixir
defmodule MeuProjetoWeb.AuthController do
  use MeuProjetoWeb, :controller

  alias MeuProjeto.Auth.Guardian
  alias MeuProjeto.Contas

  # POST /auth/registrar
  def registrar(conn, %{"nome" => nome, "email" => email, "password" => password}) do
    attrs = %{nome: nome, email: email, password: password}

    case Contas.create_usuario(attrs) do
      {:ok, usuario} ->
        {:ok, token, _claims} = Guardian.encode_and_sign({:usuario, usuario})

        conn
        |> put_status(:created)
        |> json(%{token: token, usuario_id: usuario.id})

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  # POST /auth/login
  def login(conn, %{"email" => email, "password" => password}) do
    case Contas.get_usuario_by_email(email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Email ou senha invalidos"})

      usuario ->
        if Bcrypt.verify_pass(password, usuario.password_hash) do
          {:ok, token, _claims} = Guardian.encode_and_sign({:usuario, usuario})

          conn
          |> put_status(:ok)
          |> json(%{token: token, usuario: %{id: usuario.id, nome: usuario.nome}})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Email ou senha invalidos"})
        end
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
```

### Controller com Acoes de Maquina de Estados

```elixir
defmodule MeuProjetoWeb.PedidoController do
  use MeuProjetoWeb, :controller

  alias MeuProjeto.Pedidos

  # POST /pedidos/:id/confirmar
  def confirmar(conn, %{"id" => id}) do
    case Pedidos.get_pedido(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Pedido nao encontrado"})

      pedido ->
        case Pedidos.confirmar_pedido(pedido) do
          {:ok, pedido_atualizado} ->
            json(conn, %{data: pedido_atualizado})

          {:error, :status_invalido} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Pedido deve estar PENDENTE para confirmar"})
        end
    end
  end

  # POST /pedidos/:id/cancelar
  def cancelar(conn, %{"id" => id}) do
    case Pedidos.get_pedido(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Pedido nao encontrado"})

      pedido ->
        case Pedidos.cancelar_pedido(pedido) do
          {:ok, pedido_atualizado} ->
            json(conn, %{data: pedido_atualizado})

          {:error, :status_invalido} ->
            conn
            |> put_status(:conflict)
            |> json(%{error: "Pedido nao pode ser cancelado"})
        end
    end
  end
end
```

### Controller para Rota Aninhada

```elixir
defmodule MeuProjetoWeb.ProdutoTagController do
  use MeuProjetoWeb, :controller

  import Ecto.Query
  alias MeuProjeto.Repo
  alias MeuProjeto.ProdutosTags.ProdutoTag

  # POST /produtos/:produto_id/tags
  def create(conn, %{"produto_id" => produto_id} = params) do
    tag_id = params["tag_id"]
    attrs = %{produto_id: produto_id, tag_id: tag_id}

    case %ProdutoTag{} |> ProdutoTag.changeset(attrs) |> Repo.insert() do
      {:ok, _} ->
        conn
        |> put_status(:created)
        |> json(%{produto_id: produto_id, tag_id: tag_id})

      {:error, changeset} ->
        conn
        |> put_status(:conflict)
        |> json(%{errors: changeset_errors(changeset)})
    end
  end

  # DELETE /produtos/:produto_id/tags/:tag_id
  def delete(conn, %{"produto_id" => produto_id, "tag_id" => tag_id}) do
    query = from pt in ProdutoTag,
      where: pt.produto_id == ^produto_id and pt.tag_id == ^tag_id

    Repo.delete_all(query)
    send_resp(conn, :no_content, "")
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
```

---

## 10. CODIGOS DE STATUS HTTP

```elixir
# Sucesso
:ok              # 200
:created         # 201
:no_content      # 204

# Erro do cliente
:bad_request     # 400
:unauthorized    # 401
:forbidden       # 403
:not_found       # 404
:conflict        # 409

# Erro do servidor
:internal_server_error  # 500
```

---

## 11. VALIDACOES DO CHANGESET

```elixir
# Validacoes disponiveis no changeset:

|> validate_required([:campo1, :campo2])           # Campos obrigatorios
|> validate_length(:nome, min: 3, max: 100)        # Tamanho string
|> validate_number(:preco, greater_than: 0)        # Numero maior que
|> validate_number(:qtd, less_than_or_equal_to: 100)
|> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)    # Regex
|> validate_inclusion(:status, ["A", "B", "C"])    # Valor em lista
|> validate_exclusion(:tipo, ["proibido"])         # Valor fora da lista
|> unique_constraint(:email)                        # Unico no banco
|> foreign_key_constraint(:categoria_id)           # FK existe
|> unsafe_validate_unique([:email], Repo)          # Valida antes de salvar
```

---

## 12. QUERIES ECTO

```elixir
import Ecto.Query

# Todos
Repo.all(Produto)

# Por ID
Repo.get(Produto, 1)        # Retorna nil se nao achar
Repo.get!(Produto, 1)       # Levanta erro se nao achar

# Por campo
Repo.get_by(Produto, nome: "Teste")

# Com where
query = from p in Produto, where: p.ativo == true
Repo.all(query)

# Com select
query = from p in Produto, select: p.nome
Repo.all(query)

# Com join
query = from p in Produto,
  join: c in Categoria, on: p.categoria_id == c.id,
  where: c.nome == "Eletronicos",
  select: p

# Com preload (carregar relacionamentos)
Repo.all(Produto) |> Repo.preload(:categoria)

# Deletar varios
query = from p in Produto, where: p.ativo == false
Repo.delete_all(query)
```

---

## 13. COMANDOS MIX UTEIS

```bash
# Criar projeto
mix phx.new meu_projeto --database mysql --no-html --no-assets

# Dependencias
mix deps.get

# Banco de dados
mix ecto.create
mix ecto.migrate
mix ecto.rollback
mix ecto.reset

# Gerar migration
mix ecto.gen.migration nome_da_migration

# Iniciar servidor
mix phx.server
iex -S mix phx.server  # Com shell interativo

# Compilar
mix compile

# Formatar codigo
mix format
```

---

## 14. PATTERN MATCHING

```elixir
# Em funcoes
def funcao(%{"campo" => valor}) do
  # valor disponivel aqui
end

def funcao(%{"tipo" => "A"} = params) do
  # params contem tudo, mas so entra aqui se tipo == "A"
end

# Com case
case resultado do
  {:ok, valor} ->
    # sucesso

  {:error, :not_found} ->
    # erro especifico

  {:error, changeset} ->
    # erro com changeset

  nil ->
    # nulo

  _ ->
    # qualquer outro
end

# Com if
if condicao do
  # verdadeiro
else
  # falso
end

# Com in
if valor in ["A", "B", "C"] do
  # valor esta na lista
end
```

---

## 15. PIPE OPERATOR

```elixir
# Sem pipe
resultado = funcao3(funcao2(funcao1(valor)))

# Com pipe (mais legivel)
resultado =
  valor
  |> funcao1()
  |> funcao2()
  |> funcao3()

# Exemplo real
conn
|> put_status(:created)
|> json(%{data: produto})
```

---

## 16. RESUMO DE ARQUIVOS NECESSARIOS

| Arquivo | Descricao |
|---------|-----------|
| `mix.exs` | Dependencias do projeto |
| `config/config.exs` | Configuracoes gerais e Guardian |
| `config/dev.exs` | Configuracao do banco dev |
| `lib/app/repo.ex` | Modulo do repositorio |
| `lib/app/entidade/entidade.ex` | Schema Ecto |
| `lib/app/entidades.ex` | Context (logica de negocio) |
| `lib/app/auth/guardian.ex` | Configuracao JWT |
| `lib/app_web/plugs/auth_pipeline.ex` | Pipeline de autenticacao |
| `lib/app_web/plugs/auth_error_handler.ex` | Handler de erro JWT |
| `lib/app_web/router.ex` | Rotas da API |
| `lib/app_web/controllers/entidade_controller.ex` | Controller |
| `priv/repo/migrations/*.exs` | Migrations |

---
