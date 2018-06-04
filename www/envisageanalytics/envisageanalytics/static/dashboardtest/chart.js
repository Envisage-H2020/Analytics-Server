import Chart from 'chart.js';

emptyChart = function(canvas, name) {
  return new Chart(canvas, {
      type: 'pie',
      data: [],
      options: {
        title:{
          display: false,
          text:name,
          fontColor:"#333",
          position: "left",
        },
        layout:{
          padding:{
            top:20,
            bottom:10,
            left:20,
            right:20,
          },
        },
        showLines: false,
        tooltips: {
            displayColors:false,
            backgroundColor:"#ededed",
            titleFontColor:"#333",
            bodyFontColor:"#333",
            xPadding:10,
            yPadding:10,
        },
        legend:{
            display:false,
        },
      },

  });
}

basicChart = function(canvas, xLabels, data, activePointNr, name, yMin, yMax) {
  let borderColors = [];
  let borderHoverColors = [];
  let pointHoverBackgroundColors = [];

  for(let i = 0; i < data.length; i++) {
    if(activePointNr === i) {
      borderColors.push("#90cd8a");
      borderHoverColors.push("#90cd8a");
      pointHoverBackgroundColors.push("#90cd8a");
    }
    else {
      borderColors.push("#9d1120");
      borderHoverColors.push("#9d1120");
      pointHoverBackgroundColors.push("#9d1120");
    }
  }

  return new Chart(canvas, {
      type: 'line',
      data: {
        labels: xLabels,
        datasets: [
            {
                label: name,
                fill: false,
                lineTension: 0.1,
                backgroundColor: "rgba(15,117,132,1)",//"rgba(157,17,32,1)",//"rgba(75,192,192,0.4)",
                //borderColor: "rgba(157,17,32,1)",//"rgba(75,192,192,1)",
                borderCapStyle: 'butt',
                borderDash: [],
                borderDashOffset: 0.0,
                borderJoinStyle: 'miter',
                pointBorderColor: borderColors,//"rgba(157,17,32,1)",//"rgba(75,192,192,1)",
                pointBackgroundColor: "#fff",//"rgba(157,17,32,1)",//"#fff",
                pointRadius: 6,
                pointBorderWidth: 4,
                pointHitRadius: 10,
                pointHoverRadius: 6,
                pointHoverBorderWidth: 4,
                pointHoverBorderColor: borderHoverColors,//"rgba(157,17,32,1)",//"#fff",//"rgba(220,220,220,1)",
                pointHoverBackgroundColor: pointHoverBackgroundColors,//"rgba(157,17,32,1)",//"#fff",//"rgba(75,192,192,1)",
                data: data,
                spanGaps: false,
            }
        ]
      },
      options: {
        title:{
          display: false,
          text:name,
          fontColor:"#333",
          position: "left",
        },
        layout:{
          padding:{
            top:10,
            bottom:10,
            left:20,
            right:20,
          },
        },
        showLines: false,
        tooltips: {
            displayColors:false,
            backgroundColor:"#ededed",
            titleFontColor:"#333",
            bodyFontColor:"#333",
            xPadding:10,
            yPadding:10,
        },
        legend:{
            display:false,
        },
        scales: {
          yAxes: [{
            ticks: {
              min: yMin,
              max: yMax,
              callback: function(value) {if (value % 1 === 0) {return value;} }
            }
          }]
        },
      },

  });
}

detailedChartLinkParams = function(questionnaireID, userID, totalScores, allowQuestionReview) {
  var obj = {};
  obj['questionnaireID'] = questionnaireID;
  obj['userID'] = userID;
  obj['totalScores'] = totalScores;
  obj['allowQuestionReview'] = allowQuestionReview;
  return obj;
}
