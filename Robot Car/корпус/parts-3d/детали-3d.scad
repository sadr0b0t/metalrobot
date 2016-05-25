
top();
//bottom();


/**
 * Верхняя часть корпуса
 */
module top() {
  linear_extrude(height=3)
    import(file="корпус-43d.dxf");
}


/**
 * Нижняя часть корпуса
 */
module bottom() {
  linear_extrude(height=3)
    import(file="днище-43d.dxf");
}
