import { alias, readOnly } from "@ember/object/computed";
import { withPluginApi } from "discourse/lib/plugin-api";
import { registerUnbound } from "discourse-common/lib/helpers";

export default {
  name: "thumbnail-edits",
  after: "preview-edits",
  initialize(container) {
    withPluginApi("0.8.12", (api) => {
      api.modifyClass("component:topic-list-item", {
        externalThumbnailUrl: alias("topic.external_thumbnail_url"),
        showThumbnail: readOnly('parentView.showThumbnail')
      });
    });
  },
};
