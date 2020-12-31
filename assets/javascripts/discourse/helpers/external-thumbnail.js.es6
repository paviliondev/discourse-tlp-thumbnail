import { registerUnbound } from 'discourse-common/lib/helpers';

registerUnbound("previewThumbnail", function (url, params) {
    return new Handlebars.SafeString(
      renderThumbnailPreview(url, params)
    );
});

var renderThumbnailPreview = function (url, params) {
    if (!url) return "";
  
    const opts = params.opts || {};
  
    if (!opts.tilesStyle && Discourse.Site.currentProp("mobileView")) {
      return `<img class="thumbnail" src="${url}"/>`;
    }
  
    const settings = Discourse.SiteSettings;
    const attrWidthSuffix = opts.tilesStyle ? "%" : "px";
    const attrHeightSuffix = opts.tilesStyle ? "" : "px";
    const css_classes = opts.tilesStyle
      ? "thumbnail tiles-thumbnail"
      : "thumbnail";
  
    const category_width = params.category
      ? params.category.topic_list_thumbnail_width
      : false;
    const category_height = params.category
      ? params.category.topic_list_thumbnail_height
      : false;
    const featured_width = opts.featured
      ? settings.topic_list_featured_width
        ? settings.topic_list_featured_width
        : "auto"
      : false;
    const featured_height = opts.featured
      ? settings.topic_list_featured_height
      : false;
    const tiles_width = opts.tilesStyle ? "100" : false;
    const tiles_height = opts.tilesStyle ? "auto" : false;
    const custom_width = opts.thumbnailWidth ? opts.thumbnailWidth : false;
    const custom_height = opts.thumbnailHeight ? opts.thumbnailHeight : false;
  
    const height =
      custom_height ||
      tiles_height ||
      featured_height ||
      category_height ||
      settings.topic_list_thumbnail_height;
    const width =
      custom_width ||
      tiles_width ||
      featured_width ||
      category_width ||
      settings.topic_list_thumbnail_width;
    const height_style = height ? `height:${height}${attrHeightSuffix};` : ``;
    const style = `${height_style}width:${width}${attrWidthSuffix}`;
  
    return `<img class="${css_classes}" src="${url}" style="${style}"/>`;
  };
  