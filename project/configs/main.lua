local sample = require("project.configs.sample")

local weblinks = {

    editor_panel = {
        title = "Editor",
        url_start = "https://custom/layout.html",
        global_path = "project/data/gl",
    },

    saldowww = {
        title = "Web Page",
        url_start = "https://custom/index.html",
        global_path = "project/data/www",
    },

    aspecttest = {
        title = "Aspect Test",
        url_start = "https://custom/index.html.twig",
        global_path = "project/data/aspect",
        site_args = {
            name = "Test Name"
        }
    },

    webgltest = {
        title = "WebGL Test",
        url_start = "https://custom/highway/highway.html",
        global_path = "project/data/js-demo-fun",
        site_args = {
            name = "Test Name"
        },
        register = {
            init = sample.lj_init,
            func1 = { funcname = "call_luajit", func = sample.lj_func, args = nil },
        },
    },

    materialism = {
        title = "Materialism",
        url_start = "https://custom/index.html",
        global_path = "project/data/materialism",
        www_dir = "https://",
        site_args = {
            name = "Test Name"
        }
    },

    google = {
        title = "Web Page",
        url_start = "https://www.google.com",
        global_path = "project/data/kakutai",
    },
}

return weblinks