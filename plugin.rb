# frozen_string_literal: true

# name: discourse-tlp-thumbnail
# about: Allows using external thumbnails in tlp plugin
# version: 0.1
# url: https://github.com/paviliondev/discourse-tlp-thumbnail
# authors: Faizaan Gagan

enabled_site_setting :tlp_thumbnail_enabled


after_initialize do
    register_topic_custom_field_type('external_thumbnail_url', :string)
    add_preloaded_topic_list_custom_field('external_thumbnail_url')
    
    PostRevisor.track_topic_field(:external_thumbnail_url) do |tc, attribute|
        tc.record_change('external_thumbnail_url', tc.topic.custom_fields['external_thumbnail_url'], attribute)
        tc.topic.custom_fields['external_thumbnail_url'] = attribute
    end

    add_to_serializer(:topic_view, :external_thumbnail_url) do
        object.topic.custom_fields['external_thumbnail_url']
    end

    add_to_serializer(:topic_list_item, :external_thumbnail_url) do
        object.custom_fields['external_thumbnail_url']
    end
end