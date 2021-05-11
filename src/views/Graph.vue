<template>
  <div class="chart-container">
    <Chart v-bind:chartData="chartData" v-bind:options="options" id="chart"/>
    <!-- <button v-on:click="fillData">Randomize</button> -->
    <input type="text" v-model="startRatio">
    <input type="text" v-model="endRatio">
    <button v-on:click="compute"> UPDATE</button>
  </div>
</template>

<script>
  import Chart from '../components/Chart.vue'

  export default {
    components: {
      Chart
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
        priceData: [],
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
        this.priceData = []
        this.xAxis = []
        this.tempRatio = Number(this.startRatio)
        this.tempAmount = (Number(this.daiAmount)/Number(this.tempRatio))
        this.tokensAmount = 50 //костыль
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

        let datasets = []
        console.log(this.tempAmount, this.tempRatio,this.coefficient, this.tokensAmount)
        for(let i = 0; i < 50;i++)
        {
          this.xAxis.push(i+1)
          let value = this.getValue()
          //console.log(value)
          this.priceData.push(value)
        }
        
        datasets.push({
              data: this.priceData,
              fill: false,
              label: 'Data',
              backgroundColor: '#f87979'
              
            })
        
        this.chartData = {
          labels: this.xAxis,
          fill: false,
          datasets: datasets
        }
        
        
      },
      update()
      {
        this.chartData = {
          labels: this.xAxis,
          datasets: [
            {
              label: "Data",
              data: this.priceData,
              fill: false,
              borderColor: '#0088cc',
              borderWidth: 4,
              type: 'scatter',
              yAxisID: 'left-y-axis'
            }
            ]
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
                    const point = parseFloat(chart.chart.data.datasets[0].data[i])
                    if (point > maxValue) {
                      maxValue = point
                    }
                    if (point < minValue) {
                      minValue = point
                    }
                  }
                  
                  chart.chart.setZoom(minValue * 0.6, maxValue * 1.5)
                }
							},
							zoom: {
								enabled: true,
								mode: 'x',
                speed: 1,
                threshold: 0,
                sensitivity: 0,
                onZoomComplete: (chart) => 
                {
                  let maxValue = 0
                  let minValue = 9007199254740990
                  const obj = chart.chart.visiblePoints
                  console.log(chart.chart)
                  for (var i = obj[0]; i < obj[obj.length - 1]; i++) {
                    const point = parseFloat(chart.chart.data.datasets[0].data[i])
                    
                    if (point > maxValue) {
                      maxValue = point
                    }
                    if (point < minValue) {
                      minValue = point
                    }
                  }

                  chart.chart.setZoom(minValue * 0.6, maxValue * 1.5)
                }
              
							}
						}
					}
        }
      }
      
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
</style>
