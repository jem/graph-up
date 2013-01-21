log = (obj) ->
  console.log obj

$ ->
  data = [
    {sleep: 0*60+15, up_at: 8*60+15},
    {sleep: 1*60+25, up_at: 9*60+37},
    {sleep: -1*60+25, up_at: 7*60+21}
  ]

  padding = 0.3
  w = 800
  h = 400

  chart_padding = 20

  x = d3.scale.ordinal().domain([0...data.length]).rangeBands([0, w], padding)
  y = d3.scale.linear().domain([-3*60, 12*60]).rangeRound([0, h])

  chart = d3.select("body").append("svg")
    .attr("class", "chart")
    .attr("width", w + 2*chart_padding)
    .attr("height", h + 2*chart_padding)
    .append("g")
    .attr("transform", "translate(#{chart_padding}, #{chart_padding})")

  chart.selectAll("rect")
    .data(data)
    .enter().append("rect")
    .attr("x", (d,i) -> x(i))
    .attr("y", (d) -> y(d.sleep))
    .attr("width", x.rangeBand())
    .attr("height", (d) -> y(d.up_at) - y(d.sleep))

  # Midnight marker.
  chart.append("text")
    .attr("x", chart_padding)
    .attr("y", y(0))
    .attr("dy", "0.25em")
    .attr("text-anchor", "end")
    .text("12am")
  chart.append("line")
    .attr("y1", y(0))
    .attr("y2", y(0))
    .attr("x1", chart_padding + 5)
    .attr("x2", w)
    .style("stroke", "#aaa")

  chart.append("text")
    .attr("x", chart_padding)
    .attr("y", y(8*60))
    .attr("dy", "0.25em")
    .attr("text-anchor", "end")
    .text("8am")
  chart.append("line")
    .attr("y1", y(8*60))
    .attr("y2", y(8*60))
    .attr("x1", chart_padding + 5)
    .attr("x2", w)
    .style("stroke", "#aaa")

  # Bed times.
  chart.selectAll("text.sleep").data(data).enter().append("text").attr("class", "sleep")
    .attr("x", (d,i) -> x(i))
    .attr("dx", x.rangeBand()/2)
    .attr("y", (d) -> y(d.sleep))
    .attr("dy", "-0.3em")
    .attr("text-anchor", "middle")
    .text((d) -> d.sleep)

  # Up times.
  chart.selectAll("text.up_at").data(data).enter().append("text").attr("class", "up_at")
    .attr("x", (d,i) -> x(i))
    .attr("dx", x.rangeBand()/2)
    .attr("y", (d) -> y(d.up_at))
    .attr("dy", "1.1em")
    .attr("text-anchor", "middle")
    .text((d) -> d.up_at)
