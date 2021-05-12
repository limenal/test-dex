<template>
  <div class="chart-container">
    <Chart v-bind:chartData="chartData" v-bind:options="options" id="chart"/>
    <!-- <button v-on:click="fillData">Randomize</button> -->
    <input type="text" v-model="startRatio">
    <input type="text" v-model="endRatio">
    <div id="slider">
      <range-slider
    class="slider"
    min="1"
    max="10"
    step="0.01"
    v-model="startRatio">
  </range-slider>
  <p>Start Ratio: {{startRatio}}</p>
    </div>
     <div id="slider">
       <range-slider
        class="slider"
        min="0"
        max="1"
        step="0.01"
        v-model="endRatio">
      </range-slider>
      <p>End Ratio: {{endRatio}}</p>
     </div>
    <button v-on:click="compute" id="button"> Add graph</button>
    <button v-on:click="deleteItems" id="button"> Delete all graphs</button>
  </div>
  
</template>

<script>
  import Chart from '../components/Chart.vue'
  import RangeSlider from 'vue-range-slider'
// you probably need to import built-in style
  import 'vue-range-slider/dist/vue-range-slider.css'

  export default {
    components: {
      Chart,
      RangeSlider
    },
    data () {
      return {
        tokensAmount: 50,
        daiAmount: 200,
        coefficient: 0,
        startRatio:0,
        endRatio: 0,
        tempRatio:0,
        tempAmount:0,
        maxCoeffZoom: 0,
        priceData: [],
        datasets: [],
        colors: [],
        index:0,
        xAxis: [],
        chartData: {},
        options:{

          responsive: true,
          maintainAspectRatio: false,
          scales: {
            yAxes: [{
                id: 'left-y-axis',
                ticks: {
                    beginAtZero:true
                }
            }]
          },
        }
      }
    },
    created: function() {
      
    },
    
    mounted () {
      //this.fillData(this.priceData, this.xAxis)
    },
    methods: {
      
      getRandomInt () {
        return Math.floor(Math.random() * (50 - 5 + 1)) + 5
      },
      getReductionCoefficient()
      {

        return (Number(this.endRatio)-Number(this.startRatio))/Number(this.tokensAmount)

      },
      setTemp()
      {
        
        this.xAxis = []
        this.tempRatio = Number(this.startRatio)
        this.tempAmount = (Number(this.daiAmount)/Number(this.tempRatio))
        this.tokensAmount = 50 //fix this
        this.coefficient = this.getReductionCoefficient()
        
        
      },
      getValue()
      {
        
        this.tempAmount  *= this.tempRatio
        this.tempRatio  += this.coefficient

        this.tempAmount *= 1/this.tempRatio
        let value = this.tempAmount * (Math.pow((Number(this.tokensAmount) / (Number(this.tokensAmount) - 1)), this.tempRatio) - 1)
        this.tokensAmount = (Number(this.tokensAmount) - 1)

        this.tempAmount += value
        
        return value
      },
      compute()
      {
        this.update()
        this.setTemp()

        
        let priceData = []
        console.log(this.tempAmount, this.tempRatio,this.coefficient, this.tokensAmount)
        for(let i = 0; i < 50;i++)
        {
          this.xAxis.push(i+1)
          let value = this.getValue()
          //console.log(value)
          priceData.push(value)
        }
        if(priceData[priceData.length-2]/priceData[priceData.length-3] >= this.maxCoeffZoom)
        {
          this.maxCoeffZoom = priceData[priceData.length-2]/priceData[priceData.length-3]
        }
        this.priceData.push(priceData)
        console.log(this.priceData)
        let colors = []
         var dynamicColors = function() {
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            return "rgb(" + r + "," + g + "," + b + "," + "0.2)";
         };
        colors.push(dynamicColors())
        this.colors.push(colors)
        this.datasets.push({
              data: this.priceData[this.index],
              fill: true,
              label: 'Prices: Start Ratio ' + this.startRatio.toString() + ' End Ratio ' + this.endRatio.toString(),
              // backgroundColor: 'rgba(254, 18, 18, 0.2)',
              backgroundColor: this.colors[this.index]
            })
        this.chartData = {
          labels: this.xAxis,
          fill: false,
          datasets: this.datasets
        }
        
        this.index+=1
      },
      update()
      {
        
        this.chartData = {
          labels: this.xAxis,
          datasets: this.datasets
        }
        this.options= 
        {
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            yAxes: [{
                id: 'left-y-axis',
                ticks: {
                    beginAtZero:true
                }
            }]
          },
          plugins: {
						zoom: {
							pan: {
								enabled: true,
								mode: 'x',
                onPanComplete: (chart) => 
                {
                  let maxValue = 0
                  let minValue = 9007199254740990
                  const obj = chart.chart.visiblePoints
                  for (var i = obj[0]; i < obj[obj.length - 1]; i++) {
                    for(var j = 0; j < chart.chart.data.datasets.length; j++)
                    {
                      const point = parseFloat(chart.chart.data.datasets[j].data[i])
                    
                      if (point > maxValue) {
                        maxValue = point
                      }
                      if (point < minValue) {
                        minValue = point
                      }
                    }
                    
                  }

                  chart.chart.setZoom(minValue * 0.6, maxValue * this.maxCoeffZoom)
                }
							},
							zoom: {
								enabled: true,
								mode: 'x',
                
                onZoomComplete: (chart) => 
                {
                  let maxValue = 0
                  let minValue = 9007199254740990
                  const obj = chart.chart.visiblePoints
                  
                  for (var i = obj[0]; i < obj[obj.length - 1]; i++) {
                    for(var j = 0; j < chart.chart.data.datasets.length; j++)
                    {
                      const point = parseFloat(chart.chart.data.datasets[j].data[i])
                      
                      if (point > maxValue) {
                        maxValue = point
                      }
                      if (point < minValue) {
                        minValue = point
                      }
                    }
                    
                  }
                  
                  chart.chart.setZoom(minValue * 0.6, maxValue * this.maxCoeffZoom)
                }
              
							}
						}
					}
        }
      },
      deleteItems()
      {
        
        for(var i = 0; i < this.index; i++)
        {
          console.log(this.chartData.datasets)
          this.chartData.datasets.pop()
          
        }
        this.index = 0
        this.update()
      },
      
    }
  }
</script>

<style>
  .chart-container {
    width:1600px;
    height: 400px;
    margin-top:150px;
    margin-left:auto;
    margin-right: auto;
  }
  #slider{
    position: relative;
    top:25px;
  }
  #button{
    position: relative;
    margin-top: 20px;
  margin-left:auto;
  margin-right:auto;
  background-color: #e0a90f;
  border: none;
  color: white;
  padding: 15px 20px;
  text-align: center;
  text-decoration: none;
  display: block;
  font-size: 16px;
  border-radius: 10px;
  top:25px;
  width:200px;
  cursor: pointer;
}
</style>
