# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require rails-ujs
#= require activestorage
#= require turbolinks
#= require select2-full
#= require_tree .

ready = undefined

$(document).on 'turbolinks:load', ready

$(document).ready ->
  ready()

ready = ->
  $("#search_service").select2({
    allowClear: true,
    dropdownAutoWidth: true,
    placeholder: "Lūdzu izvēlieties",
    dropdownParent: $('#service_select_div')
  })

  $("#search_sub_region").select2({
    allowClear: true,
    dropdownAutoWidth: true,
    placeholder: "Lūdzu izvēlieties",
    dropdownParent: $('#location_select_div')
  })
  $('#search_service').on 'change', change_search_service

@map_layer = undefined
@global_map = undefined

change_search_service = (e) ->
  option = $(e.currentTarget).find(':selected')
  service_id = option.val()
  global_map.removeLayer(map_layer) if global_map
  addLayer("institutions/search.csv?service_id=" + service_id)
