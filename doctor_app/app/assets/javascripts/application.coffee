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
#= require select2-full
#= require_tree .

ready = undefined

$(document).ready ->
  ready()

ready = ->
  $("#search_service").select2({
    allowClear: true,
    dropdownAutoWidth: true,
    placeholder: "Please choose",
    dropdownParent: $('#service_select_div')
  })

  $("#search_sub_region").select2({
    allowClear: true,
    dropdownAutoWidth: true,
    placeholder: "Please choose",
    dropdownParent: $('#location_select_div')
  })
  $('#search_service').on 'change', change_search_service
  $('#search_sub_region').on 'change', change_search_region
  $('#search_ico').on 'click', perform_search
  $('#search_text').on 'keydown', start_search

@mapLayer = undefined
@globalMap = undefined

change_search_service = (e) ->
  option = $(e.currentTarget).find(':selected')
  serviceId = option.val()
  globalMap.removeLayer(mapLayer) if globalMap
  addLayer("institutions/search.csv?service_id=" + serviceId)

change_search_region = (e) ->
  option = $(e.currentTarget).find(':selected')
  region = option.text()
  centerToCity(region)

start_search = (e) ->
  if e.keyCode == 13
    perform_search()

perform_search = (e) ->
  searchTerm = $("#search_text").val()
  if searchTerm.length > 3
    globalMap.removeLayer(mapLayer) if globalMap
    addLayer("institutions/search.csv?search_term=" + searchTerm)

@show_specialists = (address_service_id, address_id) ->
  searchTerm = $("#search_text").val()
  $.ajax
    url: "specialist_assignments/partial_list"
    type: "GET"
    data: {institution_address_service_id: address_service_id, institution_address_id: address_id, search_term: searchTerm}
    success: (data, textStatus, jqXHR) ->
      $("#detail_info_div").show()
      $(".dl-map").removeClass("wide")
      $("#detail_info_div").html(data)
      $("#close_box").on 'click', hide_specialists

@hide_specialists = ->
  $("#detail_info_div").hide()
  $("#map_div").attr("class", "12u$(xsmall) 9u")
  $(".dl-map").addClass("wide")

