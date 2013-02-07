log = (obj) ->
  console.log obj

timeFormat = (val) ->
  if val < 0
    val += 24*60

  hours = Math.floor(val / 60)
  minutes = val % 60

  s = "#{hours}:"

  if minutes < 10
    s += "0#{minutes}"
  else
    s += minutes

$ ->
  padding = 0.3
  w = 800
  h = 200

  chart_padding = 30

  for data in weeks
    x = d3.scale.ordinal().domain([0...7]).rangeBands([chart_padding, w], padding)
    y = d3.scale.linear().domain([-3*60, 13*60]).rangeRound([0, h])

    chart = d3.select("body").append("svg")
      .attr("class", "chart")
      .attr("width", w + 2*chart_padding)
      .attr("height", h + 2*chart_padding)
      .append("g")
      .attr("transform", "translate(#{chart_padding}, #{chart_padding})")

    majors = $.map [0, 8, 12], (x) -> 60*x
    chart.selectAll("line.majorGrid").data(majors).enter()
      .append("line").attr("class", "majorGrid")
      .attr("y1", y)
      .attr("y2", y)
      .attr("x1", chart_padding + 5)
      .attr("x2", w)
      .style("stroke", "#888")

    chart.selectAll("text.yLabel").data(majors).enter()
      .append("text").attr("class", "yLabel")
      .attr("x", chart_padding)
      .attr("y", y)
      .attr("dy", "0.25em")
      .attr("text-anchor", "end")
      .text(timeFormat)

    minors = $.map [-2, -1, 1, 2, 3, 4, 5, 6, 7, 9, 11], (x) -> 60*x
    chart.selectAll("line.minorGrid").data(minors).enter()
      .append("line").attr("class", "minorGrid")
      .attr("y1", y)
      .attr("y2", y)
      .attr("x1", chart_padding + 5)
      .attr("x2", w)

    # Main data.
    chart.selectAll("rect")
      .data(data)
      .enter().append("rect")
      .attr("x", (d,i) -> x(i) + 0.5)
      .attr("y", (d) -> y(d.sleep))
      .attr("width", x.rangeBand())
      .attr("height", (d) -> y(d.up_at) - y(d.sleep))

    # Bed times.
    chart.selectAll("text.sleep").data(data).enter().append("text").attr("class", "sleep")
      .attr("x", (d,i) -> x(i))
      .attr("dx", x.rangeBand()/2)
      .attr("y", (d) -> y(d.sleep))
      .attr("dy", "-0.3em")
      .attr("text-anchor", "middle")
      .text((d) -> timeFormat(d.sleep))

    # Up times.
    chart.selectAll("text.upAt").data(data).enter().append("text").attr("class", "upAt")
      .attr("x", (d,i) -> x(i))
      .attr("dx", x.rangeBand()/2)
      .attr("y", (d) -> y(d.up_at))
      .attr("dy", "1.1em")
      .attr("text-anchor", "middle")
      .text((d) -> timeFormat(d.up_at))

    chart.selectAll("text.date").data(data).enter().append("text").attr("class", "date")
      .attr("x", (d,i) -> x(i))
      .attr("dx", x.rangeBand()/2)
      .attr("y", h)
      .attr("dy", "1.5em")
      .attr("text-anchor", "middle")
      .text((d) -> d.date.replace(/\ 201[23]/, ""))
