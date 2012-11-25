#the main chart view
class window.ChartView
    width: 800
    height: 500 #only used to restrict height of bubble chart currently
    data: []
    charts: []
    currIndex: 0

    constructor: (selector) ->
        container = d3.select selector
        @el = container.append "svg"
        @el.attr('width', @width)
        @charts.push(new BubbleChart(@el, @width, @height, []))
        @charts.push(new BarChart(@el, @width, @height, []))
        return
    #new chart data.  Set it on the current chart object and redraw
    update: (@data) ->
        @charts[@currIndex].setData(@data).draw()
        return
    #toggle the chart type. Collapse the current and draw the new type
    toggleType: (index) ->
        oldIndex = @currIndex
        @currIndex = index
        
        @charts[oldIndex].collapse( () =>
            @charts[@currIndex].setData(@data).draw()
        )

#the base chart object
class Chart
    @total: 0
    constructor: (@el, @width, @height, @data) ->

    setData:(data)->
        @data = data
        @total = 0
        for i,d of @data
            @total += d.value
        return this
    fill: d3.scale.category20c()
        
#the bubble (circle) chart type
class BubbleChart extends Chart
    draw: () ->
        bubble = d3.layout.pack()
            .sort(null)
            .size([@width, @height])
            .padding(1.5)
        bubbleData = bubble.nodes({"children" : @data}).filter((d) -> return not d.children)
        @el.selectAll("g")
            .data(bubbleData)
            .enter().append("g")
        node = @el.selectAll("g")

        node.transition().duration(500)
            .attr("transform", (d, i) -> return "translate(#{d.x},#{d.y})")
            .each("end", (d, i) =>
                if i == 0
                    node.append("circle").style("fill", (d)  => return @fill d.letter )
                    node.selectAll("circle")
                        .transition().duration(1000)
                        .attr("r", (d) -> return d.r )
                    node.append("text")
                        .attr("text-anchor", "middle").text((d) -> return d.letter)
                        .attr("dy", ".3em")
            )
        return
    collapse: (callback) ->
        @el.selectAll("text").remove()
        @el.selectAll("circle")
            .transition().duration(1000)
            .attr("r", (d) -> return 0 )
            .each("end", (d, i) =>
                if i == 0
                    @el.selectAll('*').remove()
                    callback()
            )

#basic bar chart...
class BarChart extends Chart
    
    setData: (@data) ->
        super
        @coef = @width/@total
        return this
    draw: () ->
        bars = @el.selectAll("rect")
            .data(@data)
            .enter()
            .append("rect")
        @el.selectAll("rect")
            .attr("x", 15)
            .attr("y", (d,i) -> return i*23 )
            .attr("height", 20)
            .style("fill", (d)  => return @fill d.letter )
            .transition().duration(1000)
            .attr("width", (d,i) => return Math.floor(d.value*@coef) )


        text = @el.selectAll('text')
            .data(@data)
            .enter()
            .append('text')
        @el.selectAll('text')
            .attr("x", (d,i) -> return 0 )
            .attr("y", (d,i) -> return i*23 + 15 )
            .attr("width", (d,i) -> return 20 )
            .text((d) -> return d.letter)
        return
    collapse: (callback) =>
        @el.selectAll("text").remove()
        @el.selectAll("rect")
            .transition().duration(1000)
            .attr("width", (d,i) => 
                return 0
            )
            .each("end", (d, i) =>
                if i == 0
                    @el.selectAll('*').remove()
                    callback()
            )