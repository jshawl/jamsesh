// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

function init() {
    $.getJSON("/api/current").then(render);
}

init();

function render(res) {
    console.log(res);
    if (!res.song_title) {
        $(".player").html("No song is currently playing on Spotify.");
        $(".js-genius-html").html(
            "If a song were playing, you'd see its lyrics here."
        );
        return;
    }
    // $.get("/api/tabs?q=" + res.artist_name + " " + res.song_title).then((r) => {
    //     $(".js-tabs").attr("href", r.url);
    // });
    $(".player img").attr("src", res.image);
    $(".js-song_title").html(res.song_title);
    $(".js-artist_name").html(res.artist_name);
    let i = 0;
    var int = setInterval(() => {
        const progress = res.progress_ms + ++i * 100;

        const pct = Math.round((100 * progress) / res.duration_ms);
        if (pct > 100) {
            clearInterval(int);
            init();
        }
        $(".js-progress").css("height", pct + "%");
        $(".js-ctrl-progress").val((pct + "%").slice(0, -1));
        let progressTime = Math.floor(progress / 1000);
        let durationTime = Math.floor(res.duration_ms / 1000);
        $(".js-progress-time").html(
            secondsToClock(progressTime) + " / " + secondsToClock(durationTime)
        );
    }, 100);
    let str = res.artist_name + " " + res.song_title;
    // $(".js-search-tabs").attr(
    //     "href",
    //     "https://www.ultimate-guitar.com/search.php?search_type=title&value=" +
    //     res.artist_name +
    //     " " +
    //     res.song_title
    // );
    $("[data-song-id]")
        .attr("data-song-id", res.lyrics_id)
        .attr("id", "rg_embed_link_" + res.lyrics_id);

    $.get("https://genius.com/songs/" + res.lyrics_id + "/embed.js").then(
        (res) => {
            $(".js-genius-html").empty();
            document.write = function(value) {
                $(".js-genius-html").append(value);
            };
            eval(res);
        }
    );
}

function secondsToClock(ms) {
    let minutes = Math.floor(ms / 60);
    ms -= minutes * 60;
    return String(minutes).padStart(2, "0") + ":" + String(ms).padStart(2, "0");
}