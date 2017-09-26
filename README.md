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

...
gem 'sqlite3'
gem 'mysql2'
...

gem 'therubyracer', platforms: :ruby
...
```

Então vamos atualizar as dependências do projeto rodando o comando

```
$ bundle install
```

**config/database.yml**

Neste arquivo definimos a configuração do nosso banco de dados. São definidas as configurações para 3 ambientes, sendo eles: development, test e production. Aqui é definido o adaptador do banco de dados (por padrão o sqlite, mas poderia ser mysql, postgresql etc.), hostname, username, password e nome do banco de dados. Nós vamos alterar para o mysql conforme a seguir:

```yaml
# config/database.yml

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

Para interromper o server, pressione Ctrl + C.

# Controllers, Actions e Views

Analisando o fluxo do que está acontecendo, a requisição HTTP bate no nosso servidor (rails server), que direciona para o controller/action correspondente. O resultado desta action normalmente é uma view HTML com ERB.

No caso da url `http://localhost:3000/welcome/index`, estamos acessando  o controller Welcome e a action Index. Ou seja: o controller `app/conrtollers/welcome_controller.rb` possui uma action `index` responsável por fazer todas as operações que desejamos, após isso o resultado é (por padrão) uma view HTML com ERB. **Tudo que nós definimos nesta action estará disponível para utilizar na view**. Vamos então definir uma variável na action. Abra o arquivo `app/controllers/welcome_controller.rb` e altere conforme a seguir:

```ruby
# app/controllers/welcome_controller.rb

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

Geramos nosso `WelcomeController` com o utilitário via linha de comando do Rails. Este utilitário possui muitas outras funções (utilize `$ rails --help` para todas as opções). Vamos desta vez utilizar o Scaffold Generator com o seguinte comando:

```
$ rails generate scaffold Person name:string birth_date:date email:string phone:string
```

Diversos arquivos foram gerados ou alterados. Vamos dar uma olhada nos principais:

## Migration

O arquivo é responsável pela criação da nova tabela no banco de dados. As migrations também sabem desfazer a modificação que elas estão configuradas para fazer. Neste caso, quando rodarmos a migration ela criará uma tabela no banco de dados. Quando revertida, ela excluirá esta mesma tabela. Vamos fazer uma modificação no script `db/migrate/20170901144147_create_people.rb` conforme a seguir:

```ruby
# db/migrate/20170901144147_create_people.rb

class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.date   :birth_date
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
```

Agora vamos rodar esta migration e criar a tabela no banco de dados com o seguinte comando:

```
$ rake db:migrate
```

Para reverter a migration e remover a tabela do banco de dados, basta rodar

```
$ rake db:rollback
```

## Model

Também foi criado um arquivo para o Model da aplicação. O model será responsável pela interação com a tabela no banco de dados. No model podemos adicionar algumas validações dos dados. Vamos então alterar o arquivo `app/models/person.rb` conforme a seguir:

```ruby
# app/models/person.rb

class Person < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 5, maximum: 255 }
end
```

Com isso, estamos validando o atributo `:name` com os seguintes critérios:
* `presence: true` - Torna este atributo obrigatório, não aceita branco ou nulo.
* `uniqueness: true` - Torna este atributo único, não permite dois objetos com o mesmo nome.
* `length: { minimum: 5, maximum: 255 }` - Define os valores mínimos e máximos para este atributo.

## Routes

A maneira do Rails entender qual é o controller / action que deverá ser chamado para cada requisição, de acordo com a URL acessada, é definida no arquivo `config/routes.rb`. Ao rodar o scaffold, foi adicionada a linha `resources :people`, responsável por definir todas as rotas necessárias para as operações de CRUD. Utilizando o comando `$ rails routes` podemos ver todas rodas disponíveis na aplicação, sendo as definidas pelo resource:

```
       Prefix Verb   URI Pattern                Controller#Action
       people GET    /people(.:format)          people#index
              POST   /people(.:format)          people#create
   new_person GET    /people/new(.:format)      people#new
  edit_person GET    /people/:id/edit(.:format) people#edit
       person GET    /people/:id(.:format)      people#show
              PATCH  /people/:id(.:format)      people#update
              PUT    /people/:id(.:format)      people#update
              DELETE /people/:id(.:format)      people#destroy

```

## Controller

Foi criado mais um controller para nossa aplicação, com diversas actions. Vamos ver cada uma delas:

**Index**: Lista todas as pessoas.

**Show**: Exibe uma pessoa específica de acordo com o ID informado.

**New**: Exibe o formulário para cadastrar uma nova pessoa.

**Edit**: Exibe o formulário para alterar uma pessoa existente.

**Create**: Recebe os dados do formulário da action `new`, valida, salva e redireciona para `show`.

**Update**: Recebe os dados do formulário da action `edit`, valida, salva e redireciona para `show`.

**Destroy**: Exclui uma pessoa específica de acordo com o ID informado.

## View

Criadas todas dentro de `app/views/people/`, as views correspondem às respectivas actions do controller. Algumas actions não possuem views (como `create`, `update` e `destroy`), pois após executar a sua ação redirecionam para outra action. Outras views possuem um "underline" no início do nome. Algumas views possuem a extensão .html.erb e outras .json.jbuilder. Vamos tratar aqui alguns casos.

**_form.html.erb**: Uma _partial_ para exibir o formulário de cadastrar pessoas.

**edit.html.erb**: View para exibir o form de alteração de pessoas. Utiliza a partial `_form`.

**index.html.erb**: View para listar todas as pessoas.

**new.html.erb**: View para exibir o form de criação de nova pessoa. Utiliza a partial `_form`.

**show.html..erb**: View para exibir todas as informações de uma pessoa.

## Helper

Nos helpers são definidas funcionalidades utilizadas nas views. Vamos criar um helper para exibir a data de nascimento da pessoa no formado dd/mm/yyyy ao invés de yyyy-mm-dd alterando o arquivo `app/helpers/people_helper.rb` conforme a seguir:

```ruby
# app/helpers/people_helper.rb

module PeopleHelper
  def date_to_br(date)
    return if date.nil?

    date.strftime('%d/%m/%Y')
  end
end
```

Agora vamos utilizar este método em 2 lugares: Na view das actions `index` e `show`. Primeiro vamos alterar a view `app/views/people/index.html.erb`, alterando a linha que exibe o nascimento da pessoa, conforme a seguir:

```
...

<td><%= date_to_br(person.birth_date) %></td>

...
```

E então vamos alterar a view `app/views/people/show.html.erb` conforme a seguir:

```
...

<%= date_to_br(@person.birth_date) %>

...
```

## Testando a aplicação

Finalmente vamos acessar o que fizemos até agora. Rode o comando

```
$ rails server
```

e então abra no navegador a URL

```
http://localhost:3000/people
```

# Adicionando um segundo model

Inicialmente criamos um model com pessoas, contendo o nome, data de nascimento, telefone e email. E se a pessoa tiver mais de um telefone? Vamos lidar com isso criando um novo model, responsável por armazenar todos os telefones de uma pessoa.

## Migration / Model

Vamos utilizar o generator mais uma vez, desta vez para gerar apenas o model, conforme a seguir:

```
$ rails generate model Phone number:string person:references
```

Este comando gerará alguns arquivos. Vamos dar uma olhada primeiramente no `app/models/phone.rb`. A principal diferença do model Person é a definição `belongs_to :person`, que configura uma associação no Active Record. A palavra-chave `references` utilizada na linha de comando do generator determina um tipo de dado especial para Models. Ela cria uma nova coluna na tabela do banco de dados. O nome do model informado é acressido pelo sufixo **_id** e é tratado como um valor do tipo integer. Vamos então dar uma olhada na migration criada, em `db/migrate/20170901183624_create_phones.rb`

A definição de `t.references` cria uma coluna do tipo Integer chamada `person_id`, um índice para esta coluna, e também uma constraint do tipo foreign_key que aponta para a coluna `id` da tabela `people`.

Também precisamos uma migration para remover a coluna `phone` da tabela people. Novamente vamos utilizar o generator conforme a seguir:

```
$ rails generate migration RemovePhoneFromPeople
```
e adicionar ao arquivo criado `db/migrate/20170901201828_remove_phone_from_people.rb` o seguinte conteúdo:

```ruby
class RemovePhoneFromPeople < ActiveRecord::Migration[5.1]
  def change
    remove_column :people, :phone, :string
  end
end
```

Vamos agora rodar as migrations com a linha

```
$ rake db:migrate
```

O Rails é inteligente o suficiente para executar apenas as migrations que ainda não foram executadas no banco de dados atual. Então o output desta migration deverá ser apenas algo como

```
== CreatePhones: migrating =====================================
-- create_table(:phones)
  -> 0.0980s
== CreatePhones: migrated (0.0982s) ============================

```

## Associando os Models

As associações do Active Record permitem facilmente declarar os relacionamentos entre dois models. No caso de Pessoas (Person) e Telefones (Phone) podemos dizer que:

1. Cada telefone pertence _(belongs to)_ à uma pessoa.
2. Cada pessoa pode ter diversos _(has many)_ telefones.

Vamos transcrever isso para nossos models. O model Phone já possui esta definição, conforme a seguir:

```ruby
# app/models/phone.rb

class Phone < ApplicationRecord
  belongs_to :person

  validates :number, presence: true
end
```

onde `belongs_to :person`, traduzindo literalmente do inglês, significa "pertence a uma pessoa". Vamos definir a relação no model Person.

```ruby
# app/models/person.rb

class Person < ApplicationRecord
  has_many :phones

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 5, maximum: 255 }
end
```

onde `has_many :phones`, traduzindo literalmente do inglês, significa "possui muitos phones".

## Adicionando uma Rota para os telefones

Como não utilizamos o scaffolding generator aqui, precisamos ensinar para nossa aplicação sobre as rotas relacionadas aos telefones. Vamos então alterar o arquivo `config/routes.rb`

```ruby
# config/routes.rb

Rails.application.routes.draw do
  resources :people do
    resources :phones
  end

  ...
```

## Gerando o Controller

Vamos gerar o controller para gerenciar os telefones da pessoa:

```
$ rails generate controller Phones
```

e então vamos criar a action responsável por adicionar telefones à pessoa

```ruby
# app/controllers/phones_controller.rb

class PhonesController < ApplicationController
  def create
    @person = Person.find(params[:person_id])
    @phone	= @person.phones.create(phone_params)

    redirect_to person_path(@person)
  end

  def destroy
    @person = Person.find(params[:person_id])
    @phone  = @person.phones.find(params[:id])
    @phone.destroy

    redirect_to person_path(@person)
  end

  private
    def phone_params
      params.require(:phone).permit(:number)
    end
end
```

## Ajeitando as views

Após a modificação no banco de dados, algumas views precisam também de alguns ajustes. Vamos por cada uma delas então.

### People#index

No arquivo `app/views/people/index.html.erb` vamos apenas remover a coluna _phone_  da tabela. Removeremos a `<th>` e a `<td>` referentes à essa coluna.

### People#_form

Neste arquivo apenas vamos remover a `<div>` com as informações do telefone.

### People#show

Este será o arquivo com maiores modificações. Vamos executar vários passos neste arquivo, sendo eles:

1. Remover as informações do atributo `:phone`. A classe `Person`, que se refere à tabela `people`, não possui mais esta coluna.
2. Adicionar informações do relacionamento `Person.phones` em um _loop_
3. Criar um form para adicionar novos telefones
4. Adicionar um link para excluir telefones
5. Adicionar um JavaScript para ocultar / exibir o formulário para cadastrar novo telefone.

Após estas modificações, o arquivo ficará assim:

```html
<p id="notice"><%= notice %></p>

<p>
  <strong>Name:</strong>
  <%= @person.name %>
</p>

<p>
  <strong>Birth date:</strong>
  <%= date_to_br(@person.birth_date) %>
</p>

<p>
  <strong>Email:</strong>
  <%= @person.email %>
</p>

<h2>Phones</h2>

<ul>
  <% @person.phones.each do |phone| %>
    <li>
      <%= link_to '[x]',  person_phone_path(@person, phone), data: { confirm: 'Are you sure?' }, method: :delete %>
      <%= phone.number %>
    </li>
  <% end %>
</ul>

<a href="#" onclick="toggleForm()">
  [+] Add phone
</a>

<fieldset id="phone_form" style="display: none">
  <legend>Add new phone</legend>

  <%= form_for([@person, @person.phones.build]) do |f| %>
    <div class="field">
      <%= f.label :number %>
      <%= f.text_field :number %>
    </div>

    <div class="actions">
      <%= f.submit %>
    </div>
  <% end %>
</fieldset>

<%= link_to 'Edit', edit_person_path(@person) %> |
<%= link_to 'Back', people_path %>

<script type="text/javascript">
  function toggleForm(){
    obj = document.getElementById('phone_form');
    if(obj.style.display == 'none'){
      obj.style.display = 'block';
    } else {
      obj.style.display = 'none';
    }
  }
</script>
```


### Application.js

Vamos alterar o arquivo `app/assets/javascripts/application.js` e remover a linha do turbolinks. Algumas funcionalidades Javascript não funcionam bem quando o turbolinks está na aplicação, como o `toggleForm()` anterior.

### Ajeitando o controller de Pessoas

No arquivo `app/controllers/people_controller.rb` vamos apenas remover o `:phone` dos parâmetros permitidos. Vamos alterar o método `person_params`, deixando assim:

```ruby
# Never trust parameters from the scary internet, only allow the white list through.
def person_params
  params.require(:person).permit(:name, :birth_date, :email)
end
```

# Próximos passos

Algumas sugestões:

* Na listagem de pessoas, exibir os telefones na tabela. Veja Eager Loading e a gem `bullet`
* Na visualização da pessoa, mover o javascript para o arquivo `app/assets/javascripts/people.coffee`, veja sobre CoffeeScript.
* Na visualização da pessoa, fazer o cadastro e exclusão de telefones utilizando ajax.
* Adicionar uma máscara para o campo telefone
