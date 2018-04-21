
(function(window, undefined){

  window.frameTime = -1;
  window.frameIndex = -1;
  window.frameDuration = 10;

  window.Asc.plugin.onCommandCallback = function() {

    var time = new Date().getTime();
    if (window.frameTime == -1)
    {
      window.frameTime = time;
    }
    else
    {
      var delay = time - window.frameTime;
      if (delay < window.frameDuration)
      {
        setTimeout(function() {
          window.Asc.plugin.onCommandCallback();
        }, window.frameDuration - delay);
      }
      else
      {
        window.frameTime = time;
      }
    }

    window.frameIndex++;
    if (window.frameIndex >= window.data.length)
    {
      this.executeCommand("close", "");
      return;
    }
    Asc.scope.st = window.data[window.frameIndex];
    var Sheet;
    this.callCommand(function() {
      var Sheet = Sheet || Api.GetActiveSheet();
      // var Api = Asc.editor
      // var Range = Sheet.GetRange('A1:GH200')
      // Range.SetColumnWidth(1)
      // Range.SetRowHeight(10)
        Asc.scope.st.forEach(function(cell) {
          Sheet.GetRange(cell[0]).SetFillColor(Api.CreateColorFromRGB(cell[1][0], cell[1][1], cell[1][2]));
        })
    }, false);
    console.log(window.frameIndex);
  }
  window.Asc.plugin.init = function()
  {
    this.onCommandCallback();
  };
})(window, undefined);