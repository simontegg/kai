exports.config = {
  files: {
    javascripts: {
      joinTo: {
        "js/app.js": /^(web\/static\/js)|(node_modules)/,
        "js/ex_admin_common.js": ["web/static/vendor/ex_admin_common.js"],
        "js/admin_lte2.js": ["web/static/vendor/admin_lte2.js"],
        "js/jquery.min.js": ["web/static/vendor/jquery.min.js"],
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": /^(web\/static\/css)/,
        "css/admin_lte2.css": "web/static/vendor/admin_lte2.css"
      },
      order: {
        after: ["web/static/css/app.css"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  plugins: {
 //   babel: {
 //     ignore: [/web\/static\/vendor/]
 //   }
 //   postcss: {
 //     processors: [
 //       require('postcss-import')()
 //     ]
 //   }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
