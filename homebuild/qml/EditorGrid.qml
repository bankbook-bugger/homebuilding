/*2022.6.24
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

Canvas {
  id: grid
                         //网格 每一个网格的大小 32 *容器的大小
  property real gridSize: editorOverlay.scene.gridSize * container.scale
  property string gridColor: "grey" //网格线的颜色

  property var container         //容器

  x: {                           //每个实例在网格里x的值
    if(container) {
      return (container.x % gridSize)
    }
    else {
      return 0
    }
  }
  y: {                             //每个实例在网格里y的值
    if(container) {
      return (container.y % gridSize) - gridSize
    }
    else {
      return 0
    }
  }

  //鼠标点击网格时 整体的长宽
  width: editorOverlay.width + gridSize
  height: editorOverlay.height + gridSize

  //开始时绘制，每次更改网格大小时
  onPaint: drawGrid()
  function drawGrid()
  {
    var context = getContext("2d");   //定义2D画布的背景
    context.clearRect(0, 0, grid.width, grid.height)//清理画布

    context.beginPath()    //初始化图形上下文和 设置颜色
    context.lineWidth = 0.4 * container.scale;
    context.strokeStyle = gridColor


    var xSize = grid.width //将网格大小设置成x,y值
    var ySize = grid.height

    //垂直网格线
    for(var x = 0; x*gridSize < xSize; x++)
    {
      context.moveTo(x*gridSize, 0)
      context.lineTo(x*gridSize, ySize)
    }

    //水平网格线
    for(var y = 0; y*gridSize < ySize; y++)
    {
      context.moveTo(0, y*gridSize)
      context.lineTo(xSize, y*gridSize)
    }

    context.stroke()   //使用当前描边样式描边子路径
    context.closePath()//关闭画布
  }
}
