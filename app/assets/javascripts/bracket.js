
$.ajax({
  url: "matches.json",
  dataType: 'json',
  success: function(data) {
    var bracketData = {
      teams : [],
      results : []
    }

    // Add teams
    var t = [];
    for (var i = 0; i < data.length; i++) {
      t.push(data[i].name);
      if (t.length == 2) {
        bracketData.teams.push(t);
        t = [];
      } else if (i == data.length-1) {
        t.push('');
        bracketData.teams.push(t);
      }
    }

    // Fill up so we have enough empty matches, if needed
    var minimum = Math.pow(2, Math.log(bracketData.teams.length)/Math.log(2));
    while (bracketData.teams.length < minimum) {
      bracketData.teams.push(['',''])
    }

    // Get results and fill em in


    $(function() {
      $('.bracket').bracket({
        skipConsolationRound: true,
        init: bracketData});
    });
  }
});

