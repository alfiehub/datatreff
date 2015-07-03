
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
      if (t.length == 2 | i == data.length-1) {
        bracketData.teams.push(t);
        t = [];
      }
    }


    $(function() {
      $('.bracket').bracket({
        skipConsolationRound: true,
        init: bracketData});
    });
  }
});

