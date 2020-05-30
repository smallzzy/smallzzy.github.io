// TODO: Add scramble mode.


// DAIEBRNSEOLIXOEHADOPOEIKABSKIIKOTHORPOHHA

// url:  "/do_something"
// type: "POST"
// request: a javascript value that will be JSON encoded
// on_success: callback function
// on_error: callback function
function xmlrequest(url, type, request, on_success, on_error)
{
   var xmlhttp = new XMLHttpRequest();

   xmlhttp.onreadystatechange = function() {
       if (xmlhttp.readyState == 4) {
           if (xmlhttp.status == 200) {
               on_success(xmlhttp, xmlhttp.response);
           } else {
               if (on_error)
                   on_error(xmlhttp);
           }
       }
   };

   xmlhttp.open(type, url, true);
   xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

   // this header must be set by the browser. the standard says a browser should
   // terminate a request if Content-length or Connection are specified.
   //    xmlhttp.setRequestHeader("Content-length", data.length);
   xmlhttp.send(JSON.stringify(request));
}

// passes json-parsed result to on_success
function xmlrequest_json(url, request, on_success, on_error)
{
//   console.log("xmlrequest_json: "+document.location.origin + url);

   xmlrequest(url, "POST", request,
      function(xmlhttp, raw) {
         var resp = JSON.parse(xmlhttp.response);
          if (resp == null)
              on_error(xmlhttp, resp);
          else
              on_success(xmlhttp, resp);

      },
      on_error);
}

var all_solutions = null;
var solve_mode = ""; // "dictionary" or "statistics"

// count the # of characters, excluding spaces, where strings 'a' and
// 'b' differ. (Note, this differs slightly from the definition used
// in the C code.)
function hamming(a, b)
{
    var aidx = 0, bidx = 0;
    var hamming = 0;

    while (aidx < a.length && bidx < b.length) {
        if (a[aidx] == ' ') {
            aidx++;
            continue;
        }
        if (b[bidx] == ' ') {
            bidx++;
            continue;
        }
        if (a[aidx] != b[bidx]) {
            hamming++;
        }
        aidx++;
        bidx++;
    }
    return hamming;
}

function merge_results(this_solutions)
{
    if (this_solutions == undefined) {
        this_solutions = [];
        console.log("merge_results: solutions undefined");
    }

    // make a copy of these solutions
    for (var i = 0; i < this_solutions.length; i++) {
        // don't add duplicate solutions
        if (all_solutions.keys.hasOwnProperty(this_solutions[i].key))
            continue;
        all_solutions.keys[this_solutions[i].key] = true;
        all_solutions.push(this_solutions[i]);
    }

    // sort by log probability, most probable first
    all_solutions.sort(function(a,b) {
        return b.logp - a.logp;
    });

    var best_sol = this_solutions[0];

    var hamms = [ ];
    for (var i = 0; i < 100; i++) {
        hamms.push({ logp: -999999999,
                     plaintext: "",
                     invalid: true });
    }

    for (var i = 0; i < all_solutions.length; i++) {
        var h = hamming(all_solutions[i].plaintext, all_solutions[0].plaintext);

        if (h >= hamms.length)
            continue;

        if (all_solutions[i].logp > hamms[h].logp)
            hamms[h] = all_solutions[i];
    }

    var display_sols = [];

    if (solve_mode == "statistics") {
        // show a good diverse set of solutions using the hamming distance heuristic.
        for (var i = 0; i < hamms.length; i++) {
            if (hamms[i].invalid)
                continue;
            display_sols.push(hamms[i]);
        }

        // re-sort by log probability, most probable first
        // (hamming distance isn't the same as logp)
        display_sols.sort(function(a,b) {
            return b.logp - a.logp;
        });

        var max_display_sols = 200;
        if (display_sols.length > max_display_sols)
            display_sols.length = max_display_sols;
    } else {
        // just show the top N solutions.
        for (var i = 0; i < all_solutions.length; i++)
            display_sols.push(all_solutions[i]);

        // "dictionary" mode
        var max_display_sols = 200;
        if (display_sols.length > max_display_sols)
            display_sols.length = max_display_sols;
    }

    if (display_sols.length == 0) {
        var nosol = { "logp" : -Infinity,
                      "plaintext" : "no solutions found" };
        display_sols.push(nosol);
    }

    // update table

    // ensure that the table is:
    //   #rows: display_sols.length
    //   #cols: 2
    var table_el = document.getElementById("soltable");
    while (table_el.rows.length < display_sols.length) {
        var row = table_el.insertRow(-1);
        while (row.cells.length < 3)
            var cell0 = row.insertCell(-1);
        row.cells[0].className = "soltable_index";
        row.cells[1].className = "soltable_logp";
        row.cells[2].className = "soltable_plaintext";
    }

    for (var i = 0; i < display_sols.length; i++) {
        var row = table_el.rows[i];
        row.cells[0].innerHTML = ""+i;
        row.cells[1].innerHTML = display_sols[i].logp.toFixed(3);
        row.cells[2].innerHTML = display_sols[i].plaintext;
    }
}

var fire_request_in_progress = 0;

function progress(amt)
{
    var el = document.getElementById("progressbar_fg");
    el.style.width = ""+(100*amt)+"%";
}

function fire_request(method, request, time, finished)
{
    fire_request_in_progress++;
    if (fire_request_in_progress == 1) {
        document.getElementById("solve-button").className = "solve_button_disabled";
        document.getElementById("ciphertext").readOnly = true;
        document.getElementById("clues").readOnly = true;
//        document.getElementById("solve-spaces").disabled = true;
    }

    request["time"] = time;

    function cleanup() {
        fire_request_in_progress--;
        if (fire_request_in_progress == 0) {
            document.getElementById("solve-button").className = "solve_button";
            document.getElementById("ciphertext").readOnly = false;
            document.getElementById("clues").readOnly = false;
//            document.getElementById("solve-spaces").disabled = false;
        }
        finished();
    };

    function on_error(m) {
        alert("Solve request failed; see console.");
        console.log(m);
        cleanup();
    };

    function on_success(_response) {

        var resp = JSON.parse(_response.response);

        merge_results(resp.solutions);
        cleanup();
    };

    xmlrequest_json("https://6n9n93nlr5.execute-api.us-east-1.amazonaws.com/prod/"+method,
                    request,
                    on_success,
                    on_error);
}

function despace_ciphertext(s)
{
    var nsp = 0;

    for (var i = 0; i < s.length; i++) {
        if (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r') {
            nsp++;
        }
    }

    // If there are too many spaces, then "thin" the spaces by
    // replacing sequences of two spaces with a single space. Then
    // test for too-many spaces again.
    if (nsp > s.length / 3) {
        var out = "";
        var inarow = 0;
        for (var i = 0; i < s.length; i++) {
            if (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r') {
                inarow++;
                if (inarow > 1)
                    out = out + ' ';
            } else {
                out = out + s[i];
                inarow = 0;
            }
        }

        return despace_ciphertext(out);
    } else {
        return s;
    }
}

function denumber_ciphertext(s)
{
    var nnum = 0;
    var filtered = "";

    for (var i = 0; i < s.length; i++) {
        if (s[i] >= '0' && s[i] <= '9') {
            nnum++;
        } else {
            filtered += s[i];
        }
    }

    if (nnum > s.length / 3) {
        return filtered;
    } else {
        return s;
    }
}

function should_solve_spaces(s)
{
    s = s.trim();

    // compute a histogram of the word length
    var lenhist = [ 0 ];
    var nwords = 0; // how many words?

    var len = 0;
    for (var i = 0; i < s.length; i++) {
        if (s[i] == ' ' || s[i] == '\t' || s[i] == '\n' || s[i] == '\r' || i == (s.length - 1)) {
            while (lenhist.length <= len)
                lenhist.push(0);

            // do nothing when we see multiple spaces in a row
            if (len > 0) {
                lenhist[len]++;
                nwords++;
                len = 0; // start counting again
            }
        } else {
            len++;
        }
    }

    // no input? avoid divide by zero
    if (nwords == 0)
        return true;

    var entropy = 0;
    for (var i = 0; i < lenhist.length; i++) {
        if (lenhist[i] == 0)
            continue;
        var p = lenhist[i] / nwords;
        entropy += - p * Math.log(p);
    }

    var thresh = 1.0;

    var willsolve = entropy < thresh;
    if (nwords <= 2 && s.length < 22)
        willsolve = false;

    console.log("entropy of spaces: "+entropy+" thresh: "+thresh+". Will "+ (willsolve ? "" : "NOT ") +"solve for spaces.");

    return willsolve;
}

var ciphertext_last = null, clues_last = null, solvespaces_last = false;
var mode_last = null;

function on_solve_button()
{
    if (document.getElementById("solve-button").className == "solve_button_disabled")
        return;

    var ciphertext = document.getElementById("ciphertext").value.trim();
    ciphertext = denumber_ciphertext(despace_ciphertext(ciphertext));
    document.getElementById("ciphertext").value = ciphertext;

    var clues = document.getElementById("clues").value;

    var mode = document.getElementById("mode_value_span").innerHTML;

    if (ciphertext != ciphertext_last ||
        clues != clues_last ||
        solvespaces != solvespaces_last ||
        mode != mode_last ||
        all_solutions == null) {

        all_solutions = [ ];
        all_solutions.keys = { };

        var table_el = document.getElementById("soltable");

        while (table_el.rows.length > 0)
            table_el.deleteRow(0);
    }

    ciphertext_last = ciphertext;
    clues_last = clues;
    solvespaces_last = solvespaces;
    mode_last = mode;

    var request = { "ciphertext" : ciphertext,
                    "clues" : clues,
                  };


    var nfin = 0; // how many requests finished?
    var nreq = 0; // how many requests?

    function progress_increment()
    {
        nfin++;
        progress(1.0 * nfin / nreq);
    }

    if (mode == "auto") {
        var solvespaces = should_solve_spaces(ciphertext);
        if (solvespaces)
            mode = "statistics";
        else
            mode = "dictionary";
    }

    if (mode == "statistics") {
        console.log("using statistical solver");
        solve_mode = "statistics";

        //    var solvespaces = document.getElementById("solve-spaces").checked;
        var solvespaces = should_solve_spaces(ciphertext);

        request["solve-spaces"] = solvespaces;

        nreq++; fire_request("solve", request, 0.5, progress_increment);
        nreq++; fire_request("solve", request, 1.0, progress_increment);
        nreq++; fire_request("solve", request, 2.0, progress_increment);
        nreq++; fire_request("solve", request, 3.0, progress_increment);

        for (var i = 0; i < 1; i++) {
            nreq++; fire_request("solve", request, 4.0, progress_increment);
        }
    } else {
        console.log("using dictionary solver");
        solve_mode = "dictionary";

        if (1) {
            // create some results after a relatively short amount of time
            var nshards = 3;
            for (var i = 0; i < nshards; i++) {
                var this_request = JSON.parse(JSON.stringify(request));
                this_request["shards"] = nshards;
                this_request["shardidx"] = i;
                nreq++; fire_request("dict", this_request, 3.0, progress_increment);
            }
        }

        if (1) {
            // provide better results eventually...
            var nshards = 7;
            for (var i = 0; i < nshards; i++) {
                var this_request = JSON.parse(JSON.stringify(request));
                this_request["shards"] = nshards;
                this_request["shardidx"] = i;
                nreq++; fire_request("dict", this_request, 7.0, progress_increment);
            }
        }

        solve_mode = "statistics";
        request["solve-spaces"] = false;
        nreq++; fire_request("solve", request, 2.0, progress_increment);
        nreq++; fire_request("solve", request, 7.0, progress_increment);
    }

    // create progress indicators that happen just by virtue of the
    // fact that time passes. This helps UX by reassuring user that
    // ther system is up.
    var bogoprogress = [ 0, 1000, 2000 ];
    for (var i = 0; i < bogoprogress.length; i++) {
        nreq++;
        window.setTimeout(function() { progress_increment(); }, bogoprogress[i]);
    }
}


function on_mode()
{
    var el = document.getElementById("mode_value_span");

    var modes = [ "auto", "dictionary", "statistics" ];

    var curmode = el.innerHTML;

    var curidx = -1;
    for (var i = 0; i < modes.length; i++) {
        if (modes[i] == curmode) {
            curidx = i;
            break;
        }
    }

    // Note: selects curidx = 0 if curmode doesn't match anything.
    curidx = (curidx + 1) % modes.length;
    el.innerHTML = modes[curidx];

//    localStorage["mode"] = JSON.stringify(el.innerHTML);
}


// run-once code
/*
if (localStorage.hasOwnProperty("mode")) {
    var val = JSON.parse(localStorage.mode);
    if (val == "dictionary" || val == "statistics") {
        window.onload = function() {
            var el = document.getElementById("mode_value_span");
            el.innerHTML = val;
        };
    }
    }*/

window.onload = function() {

    on_mode();
};
