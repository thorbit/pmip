var context = undefined

function locate(locator, c) {
    //TODO: find out who or what is 'c'?
    return safe_context().evaluate(locator, c || safe_context(), null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

function exist(locator, c) {
    return locate(locator, c) != null;
}

function mandatory(locator) {
    var element = locate(locator);
    if (!element) {
        throw new Error("could not find mandatory element for the locator:\n" + locator);
    }
    return element;
}

function element(attribute, value) {
    return '//*[@' + attribute + '="' + value + '"]';
}

function name(value) {
    return element('name', value);
}

function id(value) {
    return element('id', value);
}

//WIP
function text(value) {
    return '//*[text()="' + value + '"]';
}

//function class(value) {
//    return element('class', value);
//}

function value(value) {
    return element('value', value);
}

function fireEvent(element, event) {
    if (safe_context().createEvent) {
        // dispatch for firefox + others
        var evt = safe_context().createEvent("HTMLEvents");
        evt.initEvent(event, true, true);
        return !element.dispatchEvent(evt);
    } else {
        // dispatch for IE
        return element.fireEvent('on' + event, safe_context().createEventObject());
    }
}

function safe_context() {
    if (typeof context  == "undefined") {
        throw new Error("context has not been set - you need to call using with a document. e.g. using(window.document); or using(window.frames[1].document);");
    }
    return context;
}

function click(locator) {
    return fireEvent(mandatory(locator), "click");
}

function type(value, locator) {
    var element = mandatory(locator);
    element.focus;
    element.value = value;
    element.blur;
}

//TODO:
//- exit on after too many attempts
function on(condition, action) {
    if (!condition()) {
        setTimeout('on(' + condition + ',' + action + ')', 100);
        return;
    } else {
        action();
    }
}

function using(document, action) {
    try {
        context = document;
        action();
    }
    catch(e) {
        window.alert("Problem: while executing bookmarklet: [" + e.message + "]");
    }
}
