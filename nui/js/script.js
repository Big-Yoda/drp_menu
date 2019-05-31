var menus = {}

function create(t, s, buttons, id, rName)
{
    if (!menus[id]) {
        console.log("ID: " + id)
        menus[id] = rName
        $('.menus').append('<div class="menu" id="' + id + '" style="display:none;"></div>');
        $(".menus div#" + id).append('<a class="title">' + t + '</a>');
        $(".menus div#" + id).append('<a class="subtitle">' + s + '</a>');
        $(".menus div#" + id).append('<li class="button"></li>');
        for (var i=0;i<Object.entries(buttons).length;i++)
        {
            let string = ``;
            for (let a in Object.entries(buttons)[i][1]) {
                let values = Object.entries(buttons)[i][1][a];
                let key = a;
                string += `${a}="${values}" `
            }
            // console.log(string)
            if (i == 0)
            {
                $(".menus div#" + id + " li.button").append(`<ul class="active" ${string}>${Object.entries(buttons)[i][1]["label"] || ""}</ul>`)
            }
            else
            {
                $(".menus div#" + id + " li.button").append(`<ul ${string}>${Object.entries(buttons)[i][1]["label"] || ""}</ul>`)
            }
        }
    }
}

function closeMenu(id) {
    $(".menus div#" + id).css({display: "none"});
}

function deleteMenu(id) {
    $(".menus div#" + id).empty();
    menus[id] = undefined;
}

function handleControl(state, id, rName)
{
    switch(state)
    {
        case "up":
                var $toHighlight = $('.menus div#'+id+' .active').prev().length > 0 ? $('.menus div#'+id+' .active').prev() : $('.menus div#'+id+' li.button ul').last();
                $('.menus div#'+id+' .active').removeClass('active');
                $toHighlight.addClass('active');
                break;
        case "down":
                var $toHighlight = $('.menus div#'+id+' .active').next().length > 0 ? $('.menus div#'+id+' .active').next() : $('.menus div#'+id+' li.button ul').first();
                $('.menus div#'+id+' .active').removeClass('active');
                $toHighlight.addClass('active');
            break;
        case "open":
                $('.menus div#' + id).css({display: "block"})
                console.log("OPEN")
            break;
        case "hide":
                closeMenu(id)
            break;
        case "close":
                deleteMenu(id)
                $('.menus div#' + id).css({display: "none"})
            break;
        case "enter":
            let addda = {};
            $(".menus div#"+id+" li.button ul.active").each(function() {
                $.each(this.attributes,function(i,a){
                    addda[a.name] = a.value;
                })
            })
            console.log(addda)
            sendData(rName, "submit_pressed", addda)
        break;
        default:break;
    }
    return;
}

$(function() {
    window.addEventListener('message', function(event) {
        console.log("Event Listener received message")
        let id = event.data.id;
        let rName = event.data.resource;
        if (event.data.display == true)
        {
            create(event.data.title, event.data.subtitle, event.data.elements, id, rName);
            handleControl("open", id, rName);
        }
        else if (event.data.display == false)
        {
            let type = event.data.close ? "close" : "hide";
            handleControl(type, id, rName);
            if (type == "close") sendData(rName, 'cancel_pressed', {})
        }
        else if (event.data.controlme)
        {
            handleControl(event.data.control, id, rName)
        }
    });
});

function sendData(rName, name, data) {
    $.post("http://"+rName+"/" + name, JSON.stringify(data), function(a) {
        return a;
    });
}
