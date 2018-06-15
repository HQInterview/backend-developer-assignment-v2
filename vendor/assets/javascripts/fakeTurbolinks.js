// Custom loader for turbolinks
window.app = {}
window.app.ready = function(code) {
    $(document).ready(code);
				$(document).on("page:load", code);
    return true;
}
