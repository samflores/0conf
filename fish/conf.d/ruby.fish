# ---- Ruby
alias rb ruby

# ---- Bundler
if type -q bundle
    alias bi 'bundle install'
    alias bu 'bundle update'
    alias bx 'bundle exec'
    alias bo 'bundle open'
    alias bl 'bundle list'
end

# ---- Rails
if type -q rails
    # Rails core
    alias rc  'rails console'
    alias rcs 'rails console --sandbox'
    alias rd  'rails destroy'
    alias rdb 'rails dbconsole'
    alias rn  'rails generate'
    alias rnM 'rails generate migration'
    alias rnm 'rails generate model'
    alias rnr 'rails generate resource'
    alias rnc 'rails generate controller'
    alias rp  'rails plugin'
    alias ru  'rails runner'
    alias rs  'rails server'
    alias rsd 'rails server --debugger'
    alias rsp 'rails server --port'

    # DB / rake-style tasks
    alias rdm  'rails db:migrate'
    alias rdms 'rails db:migrate:status'
    alias rdr  'rails db:rollback'
    alias rdc  'rails db:create'
    alias rds  'rails db:seed'
    alias rdd  'rails db:drop'
    alias rdrs 'rails db:reset'
    alias rdtc 'rails db:test:clone'
    alias rdtp 'rails db:test:prepare'
    alias rdmtc 'rails db:migrate db:test:clone'
    alias rdsl 'rails db:schema:load'
    alias rlc  'rails log:clear'
    alias rr   'rails routes'
    alias rt   'rails test'
    alias rmd  'rails middleware'
    alias rsts 'rails stats'

    function rrg --description 'rails routes | grep ...'
        rails routes | grep $argv
    end
end

