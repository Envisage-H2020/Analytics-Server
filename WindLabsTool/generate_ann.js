var _ = require('underscore');
var fs = require("fs");
var synaptic = require('synaptic');

const Layer = synaptic.Layer;
const Network = synaptic.Network;

var fileName = 'trainingData.txt';
var str = fs.readFileSync(fileName, 'utf8');


//TODO: MANUALLY PARSE THE RTEXTFILE
//RUN WITH NODEJS GENERATE_ANN.JS
//split by line
var text= str.split("\n"); 
text = text.filter(function(e){return e});  //remove any blank lines
//split into input and output
var trainingData = new Array(text.length-1);
for (i = 0; i < text.length; i++){
	var inputSelect = text[i].substring(text[i].lastIndexOf("{input: [")+9,text[i].lastIndexOf("], output:")).split(",");
	var outputSelect = text[i].substring(text[i].lastIndexOf("output: [")+9,text[i].lastIndexOf("]},")).split(",");
	trainingData[i] = {input: inputSelect, output: outputSelect};
}

//console.log(trainingData);

var inputLayer = new Layer(trainingData[0]["input"].length); 
var hiddenLayer = new Layer(0);
var outputLayer = new Layer(4);

inputLayer.project(outputLayer);

var myNetwork = new Network({
 input: inputLayer,
 hidden: [hiddenLayer],
 output: outputLayer
});

var learningRate = 0.4;
 
function train() {
    for(var i = 0; i < trainingData.length; i++) {
    	myNetwork.activate(trainingData[i]["input"]);
  		myNetwork.propagate(learningRate, trainingData[i]["output"]);
    }
}

function retrain() {
    for(var i = 0; i < 20444; i++) {
        trainingData = _.shuffle(trainingData);
        train();
    }
}
 
retrain(); // Start the training

var result = myNetwork.activate(trainingData[3]["input"]);
var sum = result[0] + result[1] + result[2] + result[3];

for (var i in result) {
	result[i] = result[i] || 0; //convert NaN results to 0
	result[i] = Math.round(result[i]/sum * 100);
}

console.log("Input: " + trainingData[3]["input"]);
console.log("Expected output: " + trainingData[3]["output"]);
console.log("Sum of outputs: " + sum)
//output answers, rounded up to 100%
console.log("Tier 1: " + result[0] + "%");
console.log("Tier 2: " + result[1] + "%");
console.log("Tier 3: " + result[2] + "%");
console.log("Tier 4: " + result[3] + "%");

var CLUSTER_COUNTS = result;
console.log(CLUSTER_COUNTS);

var exported = myNetwork.toJSON();
//console.log(exported);
var jsonData = JSON.stringify(exported);
fs.writeFile("ann.json", jsonData, function(err) {
    if(err) {
        return console.log(err);
    }
});
console.log("ANN Generation complete.");