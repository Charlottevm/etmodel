class @Setting extends Backbone.Model
  url: -> '/settings'

  # Always use PUT requests
  isNew : -> false

  toggle_fce: ->
    use_fce = !!$(this).attr('checked')
    App.settings.save
      use_fce: use_fce
    $('.fce_notice').toggle(use_fce)
    App.call_api()

  toggle_peak_load_tracking: ->
    App.settings.save
      track_peak_load: $("#track_peak_load_settings").is(':checked')

  # Used by the bio-footprint dashboard item
  country: => @get('area_code').split('-')[0]
