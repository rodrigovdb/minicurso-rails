# FTSL 2017 - Mini curso de Rails

Rails é um framework escrito com a linguagem de programação [Ruby](https://www.ruby-lang.org/pt/)

# Instalação

Como mencionado, rails é escrito em Ruby. Portanto, a linguagem Ruby disponível no computador é um pré-requisito. A linguagem Ruby possui um sistema de gerenciamento de pacotes chamado `RubyGems`, que provê um formato padrão para a distribuição de programas Ruby e bibliotecas em um formato auto-suficiente. Chamado de gem ("jóia", do inglês), uma ferramenta projetada para gerenciar facilmente a instalação de gems, e um servidor para distribui-los.

Vamos então instalar o Rails via RubyGems, utilizando a linha de comando:

```
$ gem install rails
```

E pronto.

Podemos verificar a instalação do rails, rodando também via linha de comamdo:

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

e então o próprio Rails se encarrega da criação de toda a estrutura de diretórios, além de instalar todas as dependências necessárias para o nosso projeto. Vejamos alguns arquivos:

**Gemfile**

Este é o arquivo em que declaramos as dependências do nosso projeto e sua respectiva versão. Vamos adicionar uma nova dependência neste arquivo, descomentando a seguinte linha:

```ruby
gem 'therubyracer', platforms: :ruby
```

Então vamos atualizar as dependências do projeto rodando o comando

```
$ bundle install
```

**config/database.yml**

Neste arquivo definimos a configuração do nosso banco de dados. São definidas as configurações para 3 ambientes, sendo eles: development, test e production. Aqui é definido o adaptador do banco de dados (no nosso caso o sqlite, mas poderia ser mysql, postgresql etc.), hostname, username, password e nome do banco de dados.
