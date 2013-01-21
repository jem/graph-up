log = (obj) ->
  console.log obj

$ ->
  data = [4, 8, 35, 16, 35, 23, 42]

  chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("width", 460)
    .attr("height", 330)
    .append("g")
    .attr("transform", "translate(10, 15)")

  x = d3.scale.linear().domain([0, d3.max(data)]).range([0, 420])
  y = d3.scale.ordinal().domain([0...data.length]).rangeBands([0, 300])
  window.y = y

  chart.selectAll("line")
    .data(x.ticks(10))
    .enter().append("line")
    .attr("x1", x)
    .attr("x2", x)
    .attr("y1", 0)
    .attr("y1", 330)
    .style("stroke", "#ccc")

  chart.selectAll("rect").data(data).enter().append("rect")
    .attr("y", (d,i) -> y(i))
    .attr("width", x)
    .attr("height", y.rangeBand())

  chart.selectAll("text")
    .data(data)
    .enter().append("text")
    .attr("x", x)
    .attr("y", (d,i) -> y(i) + y.rangeBand() / 2)
    .attr("dx", -10)
    .attr("dy", ".35em")
    .attr("text-anchor", "end")
    .text(String)


  chart.selectAll(".rule")
    .data(x.ticks(10))
    .enter().append("text").attr("class", "rule")
    .attr("x", x)
    .attr("y", 0)
    .attr("dy", -3)
    .attr("text-anchor", "middle")
    .text(String)
    .style("fill", "black")

  chart.append("line")
    .attr("y1", 0)
    .attr("y2", 330)
    .style("stroke", "#000")
