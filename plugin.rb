# frozen_string_literal: true

# name: discourse-tlp-thumbnail
# about: Allows using external thumbnails in tlp plugin
# version: 0.1
# url: https://github.com/paviliondev/discourse-tlp-thumbnail
# authors: Faizaan Gagan

enabled_site_setting :tlp_thumbnail_enabled
register_asset 'stylesheets/common.scss'

after_initialize do
  ::ActionController::Base.prepend_view_path File.expand_path("../app/views", __FILE__)

  register_topic_custom_field_type('external_thumbnail_url', :string)
  register_topic_custom_field_type('random_image_enabled', :boolean)

  add_preloaded_topic_list_custom_field('external_thumbnail_url')
  add_preloaded_topic_list_custom_field('random_image_enabled')

  PostRevisor.track_topic_field(:external_thumbnail_url) do |tc, attribute|
    tc.record_change('external_thumbnail_url', tc.topic.custom_fields['external_thumbnail_url'], attribute)
    tc.topic.custom_fields['external_thumbnail_url'] = attribute
  end

  PostRevisor.track_topic_field(:random_image_enabled) do |tc, attribute|
    tc.record_change('random_image_enabled', tc.topic.custom_fields['random_image_enabled '], attribute)
    tc.topic.custom_fields['random_image_enabled'] = attribute
  end

  add_to_class(:topic, :external_thumbnail_url) do
    self.custom_fields['external_thumbnail_url']
  end

  add_to_class(:topic, :random_image_enabled) do
    self.custom_fields['random_image_enabled']
  end

  add_to_class(:topic, :tlp_thumbnail_random_image) do
    if self.random_image_enabled
      return "" unless SiteSetting.tlp_thumbnail_random_image_url.present?

      uri = Addressable::URI.parse SiteSetting.tlp_thumbnail_random_image_url
      ext_param = { rand: SecureRandom.hex(10) }
      uri.query_values = uri.query_values ? uri.query_values.merge(ext_param) : ext_param
      return uri.to_s
    end

    ""
  end

  add_to_serializer(:topic_view, :external_thumbnail_url) do
    object.topic.external_thumbnail_url
  end

  add_to_serializer(:topic_list_item, :external_thumbnail_url) do
    return object.external_thumbnail_url if object.external_thumbnail_url.present?
    return object.tlp_thumbnail_random_image
  end

  add_to_serializer(:topic_view, :random_image_enabled) do
    object.topic.random_image_enabled
  end

  add_to_serializer(:topic_list_item, :random_image_enabled) do
    object.random_image_enabled
  end
end
