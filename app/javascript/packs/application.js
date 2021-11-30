// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


const main = setInterval(() => {
    $.getJSON("/api/current").then(render);
    //.catch(() => clearInterval(main)); // probably not logged in
}, 1000);

function render(res) {
    console.log(res);
    if (!res.song_title) {
        $(".player").html("No song is currently playing on Spotify.");
        $(".js-genius-html").html(
            "If a song were playing, you'd see its lyrics here."
        );
        return;
    }

    embedLyrics(`${res.artist_name} ${res.song_title} `);

    // $.get("/api/tabs?q=" + res.artist_name + " " + res.song_title).then((r) => {
    //     $(".js-tabs").attr("href", r.url);
    // });
    $(".player img").attr("src", res.image);
    $(".js-song_title").html(res.song_title);
    $(".js-artist_name").html(res.artist_name);
    let i = 0;
    const progress = res.progress_ms + ++i * 100;

    const pct = Math.round((100 * progress) / res.duration_ms);
    $(".js-progress").css("height", pct + "%");
    $(".js-ctrl-progress").val((pct + "%").slice(0, -1));
    let progressTime = Math.floor(progress / 1000);
    let durationTime = Math.floor(res.duration_ms / 1000);
    $(".js-progress-time").html(secondsToClock(progressTime));
    $(".js-progress-time-total").html(secondsToClock(durationTime));
    // $(".js-search-tabs").attr(
    //     "href",
    //     "https://www.ultimate-guitar.com/search.php?search_type=title&value=" +
    //     res.artist_name +
    //     " " +
    //     res.song_title
    // );
}

function embedLyrics(query) {
    console.log("getting song id");
    if (globalThis[query]) {
        console.log("returning early");
        return;
    }
    $.get("/api/lyrics?query=" + query).then((res) => {
        globalThis[query] = res;
        $("[data-song-id]")
            .attr("data-song-id", res[0].id)
            .attr("id", "rg_embed_link_" + res[0].id);

        $.get("https://genius.com/songs/" + res[0].id + "/embed.js").then((res) => {
            $(".js-genius-html").empty();
            document.write = function(value) {
                $(".js-genius-html").append(value);
            };
            eval(res);
        });
    });
}

function secondsToClock(ms) {
    let minutes = Math.floor(ms / 60);
    ms -= minutes * 60;
    return String(minutes).padStart(2, "0") + ":" + String(ms).padStart(2, "0");
}