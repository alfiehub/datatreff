
$.ajax({
  url: "matches.json",
  dataType: 'json',
  success: function(data) {
    var bracketData = {
      teams : [],
      results : []
    }

    // Add teams
    var teams_len = data.teams.length
    for (var i = 0; i < data.teams.length/2; i++) {
      bracketData.teams.push([]);
    }
    for (var i = 0; i < data.teams.length; i++) {
      bracketData.teams[Math.floor((data.teams[i].seed)/2)].push(data.teams[i].team_name);
    }

    var matches = Math.pow(2, Math.ceil((Math.log(bracketData.teams.length)/Math.log(2))));
    var players = matches*2;
    var l2 = Math.log(players)/Math.log(2);
    var lower_rounds = Math.ceil(l2) + Math.ceil(Math.log(l2)/Math.log(2));

    // Fill up so we have enough empty matches, if needed
    while (bracketData.teams.length < matches) {
      bracketData.teams.push(['--','--'])
    }

    // Get results and fill em in
    var results = data.results;
    // Add winner and losers bracket, plus finals
    for (var i = 0; i < 3; i++) {
      bracketData.results.push([]);
    }
    // Add winner rounds
    for (var i = 0; i < l2; i++) {
      bracketData.results[0].push([]);
      for (var n = 0; n < matches/Math.pow(2,i); n++) {
        bracketData.results[0][i].push([]);
      }
    }
    // Add lower rounds
    for (var i = 0; i < lower_rounds; i++) {
      bracketData.results[1].push([]);
      for (var n = 0; n < matches/Math.pow(2,i); n++) {
        bracketData.results[1][i].push([]);
      }
    }
    // Add final rounds
    for (var i = 0; i < 2; i++) {
      bracketData.results[2].push([]);
    }
    // Add results
    for (var i = 0; i < results.length; i++) {
      if (!results[i].lower_bracket) {
        if (results[i].round == l2+1) { // Handle finals
          bracketData.results[2][results[i].match-1].push([results[i].team1_score, results[i].team2_score]);
        } else {
          bracketData.results[0][results[i].round-1][results[i].match-1].push(results[i].team1_score);
          bracketData.results[0][results[i].round-1][results[i].match-1].push(results[i].team2_score);
        }
      } else {
        bracketData.results[1][results[i].round-1][results[i].match-1].push(results[i].team1_score);
        bracketData.results[1][results[i].round-1][results[i].match-1].push(results[i].team2_score);
      }
    }

    console.log(bracketData);

    $(function() {
      $('.bracket').bracket({
        skipConsolationRound: true,
        init: bracketData});
    });
  }
});

