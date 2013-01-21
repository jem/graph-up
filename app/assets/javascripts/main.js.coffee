log = (obj) ->
  console.log obj

$ ->
  t = 1297110663
  v = 70

  next = ->
    time: ++t
    value: v = ~~Math.max(10, Math.min(90, v + 10*(Math.random() - 0.5)))

  data = d3.range(33).map(next)

  setInterval(
    ->
      data.shift()
      data.push(next())
      redraw()
    1500
  )

  w = 20
  h = 200

  x = d3.scale.linear().domain([0, 1]).range([0, w])
  y = d3.scale.linear().domain([0, 100]).rangeRound([0, h])

  chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("width", w*data.length - 1)
    .attr("height", h)

  chart.selectAll("rect")
    .data(data)
    .enter().append("rect")
    .attr("x", (d, i) -> x(i) - 0.5)
    .attr("y", (d) -> h - y(d.value) - 0.5)
    .attr("width", w)
    .attr("height", (d) -> y(d.value))

  chart.append("line")
    .attr("x1", 0)
    .attr("x2", w*data.length)
    .attr("y1", h - 0.5)
    .attr("y2", h - 0.5)
    .style("stroke", "black")

  redraw = ->
    chart.selectAll("rect")
      .data(data)
      .transition()
      .duration(1000)
      .attr("y", (d) -> h - y(d.value) - 0.5)
      .attr("height", (d) -> y(d.value))
