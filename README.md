# FTSL 2017 - Mini curso de Rails

Rails é um framework escrito com a linguagem de programação [Ruby](https://www.ruby-lang.org/pt/)

# Instalação

Como mencionado, rails é escrito em Ruby. Portanto, a linguagem Ruby disponível no computador é um pré-requisito. A linguagem Ruby possui um sistema de gerenciamento de pacotes chamado `RubyGems`, que provê um formato padrão para a distribuição de programas Ruby e bibliotecas em um formato auto-suficiente. Chamado de gem ("jóia", do inglês), uma ferramenta projetada para gerenciar facilmente a instalação de gems, e um servidor para distribui-los.

Vamos então instalar o Rails via RubyGems, utilizando a linha de comando:

```
$ gem install rails
```

E pronto.

Podemos verificar a instalação do Rails, rodando também via linha de comamdo:

```
$ rails -v
```

É possível descobrir todas as opções disponíveis com

```
$ rails --help
```

# Criação do nosso projeto

Vamos então criar um novo projeto Ruby on Rails utilizando o utilitário de linha de comando. O nosso projeto se chamará `agenda`, então vamos rodar

```
$ rails new agenda
```

e então o próprio Rails se encarrega da criação de toda a estrutura de diretórios, além de instalar todas as dependências necessárias para o nosso projeto. Pronto, já temos um projeto Ruby on Rails :-)

## Configurações iniciais

Após a geração da estrutura do projeto, precisamos fazer algumas pequenas configurações. Vejamos alguns arquivos que vamos alterar:

**Gemfile**

Este é o arquivo em que declaramos as dependências do nosso projeto e sua respectiva versão. Vamos adicionar então a gem do `mysql`. Também vamos descomentar a linha da gem therubyracer, um runtime de javascript para utilizar no Rails.

```ruby
# Gemfile

[...]
gem 'sqlite3'
gem 'mysql2'
[...]

gem 'therubyracer', platforms: :ruby
[...]
```

Então vamos atualizar as dependências do projeto rodando o comando

```
$ bundle install
```

**config/database.yml**

Neste arquivo definimos a configuração do nosso banco de dados. São definidas as configurações para 3 ambientes, sendo eles: development, test e production. Aqui é definido o adaptador do banco de dados (por padrão o sqlite, mas poderia ser mysql, postgresql etc.), hostname, username, password e nome do banco de dados. Nós vamos alterar para o mysql conforme a seguir:

```yaml
development:
  adapter   : mysql2
  encoding  : utf8
  username  : desenv
  password  : rapadura
  host      : localhost
  database  : agenda_development

test:
  adapter   : sqlite3
  pool      : 5
  timeout   : 5000
  database  : db/test.sqlite3

production:
  adapter   : mysql2
  encoding  : utf8
  username  : desenv
  password  : rapadura
  host      : localhost
  database  : agenda_production
```

## Criação do banco de dados

Uma vez configurados adapter, credenciais e host, vamos deixar a criação do banco de dados por conta do Rails. Na verdade, todo o gerenciamento do banco de dados será feito através do Rails: criação de novas tabelas, alterações de colunas, load de dados e muito mais.

Vamos então pedir ao Rails para criar o banco de dados com o comando

```
$ rake db:create
```

e pronto. Foram criados os bancos de dados para desenvolvimento e para testes.

# Hello, Rails

O Rails é um framework MVC. As requisições HTTP chegam ao Controller, que por sua vez se comunica com o Model, renderiza uma View e devolve para o usuário. Vamos então criar um controller Welcome, este com uma action Index.

**Importante!!!**

* Utilizamos nomenclatura em inglês, sempre!
* O nome dos Controllers e dos Models sempre no singular

```
$ rails generate controller Welcome index
```

E neste momento o Rails criará diversos arquivos e rotas para nós. Os mais importantes são, é claro, o controller, localizado em `app/controllers/welcome_controller.rb` e a view, localizada em `app/views/welcome/index.html.erb`.

Vamos alterar o arquivo `app/views/welcome/index.html.erb` com o seguinte conteúdo:

```html
<h1>Hello, Rails!</h1>
```

Pronto! Temos então nosso Hello, Rails! Para testar, precisamos levantar o servidor web que já vem junto com o Rails. No terminal, execute:

```
$ rails server
```

Então acesse no navegador a URL `http://localhost:3000/welcome/index`

# Controllers, Actions e Views

Analisando o fluxo do que está acontecendo, a requisição HTTP bate no nosso servidor (rails server), que direciona para o controller/action correspondente. O resultado desta action normalmente é uma view HTML com ERB.

No caso da url `http://localhost:3000/welcome/index`, estamos acessando  o controller Welcome e a action Index. Ou seja: o controller `app/conrtollers/welcome_controller.rb` possui uma action `index` responsável por fazer todas as operações que desejamos, após isso o resultado é (por padrão) uma view HTML com ERB. **Tudo que nós definimos nesta action estará disponível para utilizar na view**. Vamos então definir uma variável na action. Abra o arquivo `app/controllers/welcome_controller.rb` e altere conforme a seguir:

```ruby
class WelcomeController < ApplicationController
  def index
    @name = params[:name]
  end
end
```

Dentro da action `index`, definimos uma variável `@name`, contendo o valor recebido como parâmetro `name`.

Agora, uma vez definida a variável `@name` na action, vamos utilizá-la na nossa view. Abra o arquivo `app/views/welcome/index.html.erb` e altere conforme a seguir:

```ruby
<h1>Hello, Rails</h1>

<% if @name -%>
  <h2>Bem vindo, <%= @name %></h2>
<% end %>
```

Adicionamos um condicional `if`, verificando se a variável @name possui valor. Caso não possua, ignoramos o bloco. Porém, caso possua, exibimos a mensagem de bem vindo.

Para testar, vamos acessar novamente a URL `http://localhost:3000/welcome/index`. Como esperado, nada diferente aconteceu, afinal não temos o parâmetro `name`. Vamos passar este parâmetro então, ficando a URL como

`http://localhost:3000/welcome/index?name=rodrigo`

# Scaffolding
