include('framework.js')

using(window.document, function() {
    type('foo', id('username'));
    type('bar', id('password'));
    click(id('submit'));
});