
$.ajax({
  url: "matches.json",
  dataType: 'json',
  success: function(data) {
    var bracketData = {
      teams : [],
      results : []
    }

    console.log(data);

    // Add teams
    var t = [];
    for (var i = 0; i < data.teams.length; i++) {
      t.push(data.teams[i].name);
      if (t.length == 2) {
        bracketData.teams.push(t);
        t = [];
      } else if (i == data.teams.length-1) {
        t.push('--');
        bracketData.teams.push(t);
      }
    }

    // Fill up so we have enough empty matches, if needed
    var minimum = Math.pow(2, Math.log(bracketData.teams.length)/Math.log(2));
    while (bracketData.teams.length < minimum) {
      bracketData.teams.push(['--','--'])
    }

    // Get results and fill em in
    var results = data.results;
    // Add winner and losers bracket, plus finals
    for (var i = 0; i < 3; i++) {
      bracketData.results.push([]);
    }
    // Add winner rounds
    for (var i = 0; i < minimum; i++) {
      bracketData.results[0].push([]);
    }
    // Add loswers rounds
    for (var i = 0; i < minimum; i++) {
      bracketData.results[1].push([]);
    }
    // Add final rounds
    for (var i = 0; i < 2; i++) {
      bracketData.results[2].push([]);
    }
    // Add results
    for (var i = 0; i < results.length; i++) {
      console.log(bracketData.results);
      if (!results[i].lower_bracket) {
        if (results[i].round == 3) { // Handle finals
          bracketData.results[2][results[i].match-1].push([results[i].team1_score, results[i].team2_score]);
        } else {
          bracketData.results[0][results[i].round-1].push([results[i].team1_score, results[i].team2_score]);
        }
      } else {
        bracketData.results[1][results[i].round-1].push([results[i].team1_score, results[i].team2_score]);
      }
    }


    $(function() {
      $('.bracket').bracket({
        skipConsolationRound: true,
        init: bracketData});
    });
  }
});

