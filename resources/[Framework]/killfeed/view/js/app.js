let feedId = 0;

function feed(event) {
    feedId += 60;
    let toDelId = feedId;
    $('.feed').append(`<div class="feed-item" id="feed-${toDelId}">${event.data.context}</div>`);
    $('body').find(`#feed-${toDelId}`).fadeIn();
    setTimeout(() => {
        $('body').find(`#feed-${toDelId}`).fadeOut();
    }, 4000);
}

function truncate(str, num) {
    if (str.length > num) {
        return str.slice(0, num) + "...";
    } else {
        return str;
    }
}

function GenerateExtendedStats(stats) {
    $(".ExtendedStats").show()
    $('.ExtendedInformation').append(`
        <div class="ExtendedlabelValue">
            <div class="NameLabel">Name</div>
            <div class="KillLabel">K</div>
            <div class="DeathLabel">D</div>
            <div class="DamageLabel">DMG</div>
        </div>
    `);
    stats.slice(0, 5).forEach(stat => {
        $('.ExtendedInformation').append(`
        <div class="ExtendedlabelValue">
            <div class="NameLabel">${truncate(stat.Name, 16)}</div>
            <div class="KillLabel">${stat.Kills}</div>
            <div class="DeathLabel">${stat.Deaths}</div>
            <div class="DamageLabel">${stat.Damage}</div>
        </div>
    `);
    });
}

function GenerateStats(stats) {
    $(".StatsInfo").show();
    stats.slice(0, 3).forEach(stat => {
        $('.information').append(`
            <div class='labelValue'>
                <div class='label'>${truncate(stat.Name, 13)}</div>
                <div class='value'>${stat.Kills}</div>
            </div>
        `);
    });
}


function GenerateList(players) {
    $(".player-list").show()
    $(".player-list").append(
        `
      <div class="player nh">
              <span class="player-list-text">NAME</span>
              <span class="player-list-text">KILLS</span>
              <span class="player-list-text">DEATHS</span>
              <span class="player-list-text">K/D Ratio</span>
      </div>`
    )

    for (x = 0; x < players.length; x++) {
        $('.player-list').append(`
        <div class="player" onclick='PlayerSelect(${players[x].id})')>
            <span class="player-list-text">${players[x].Name}</span>
            <span class="player-list-text">${players[x].Kills}</span>
            <span class="player-list-text">${players[x].Deaths}</span>
            <span class="player-list-text">${players[x].kd}</span>
            
        </div>
        `);
    }
}

let hide = ["player-list"]

function FadeAllOut() {
    $(".back-button").empty()
    for (x = 0; x < hide.length; x++) {
        $("." + hide[x]).fadeOut()
    }

}
$(function() {
    window.addEventListener("message", function(event) {
        var item = event.data;
        if (item.show) {
            if (item.type === "killfeed") {
                feed(event);
            }
            if (item.type === "ui") {
                if (item.mode === "Leaderboard") {
                    $(".player-list").empty()
                    playerlist = JSON.parse(event.data.data);
                    GenerateList(playerlist)
                    FadeInMenu("player-list")
                } else if (item.mode === "close_all") {
                    $(".player-list").hide()
                    $(".player-list").empty()
                    FadeAllOut()
                } else if (item.mode === "stats") {
                    $(".information").empty()
                    $(".ExtendedInformation").empty()
                    if (item.state) {
                        $(".StatsInfo").fadeOut()
                        $(".ExtendedStats").fadeIn()
                        GenerateExtendedStats(JSON.parse(event.data.data))
                    } else {
                        $(".ExtendedStats").fadeOut()
                        $(".StatsInfo").fadeIn()
                        GenerateStats(JSON.parse(event.data.data))
                    }
                }
            }
        } else {
            FadeAllOut()
            $(".ExtendedStats").fadeOut()
            $(".StatsInfo").fadeOut()
        }
    })

    $(document).keydown(function(e) {
        if (e.key === "Escape") {
            $.post("https://killfeed/exit", JSON.stringify({}));
        }
    });

})

function FadeInMenu(menu) {
    clss = "." + menu
    $(clss).fadeIn()
    $(".title").fadeIn()
}

function Exit() {
    $.post("https://killfeed/exit", JSON.stringify({}));
}