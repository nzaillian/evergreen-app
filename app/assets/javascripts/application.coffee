#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require codemirror
#= require codemirror/modes/css
#= require ./globals
#= require ./hot_coffee_config
#= require ./lib/manifest
#= require_tree ./answers
#= require_tree ./comments
#= require_tree ./companies
#= require_tree ./questions
#= require_tree ./tags
#= require_tree ./votes
#= require ./ui/date_localizer
#= require_self

$ready ->
  $("[data-toggle='tooltip']").tooltip()

