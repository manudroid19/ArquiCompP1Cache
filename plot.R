datos <- read.table(file = "resFixed.csv",header = TRUE,sep = "")
datos
plot(datos$L, datos$resultado,col="white",xlab="Lineas cache", ylab="Coste en ciclos por acceso",xaxt="n", log = "x")
axis(1,datos$L)
colors = rainbow(6)[c(1,3:6)]

i=1
for (value in unique(datos$D)){
  points(datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado,col=colors[i],pch=16)
  lines (datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado, type="l",lwd=3, col=colors[i])
  i=i+1
}

legend("topleft", legend=rev(paste("D =",unique(datos$D))),
       col=rev(colors), lty=1, cex=1.5, lwd=3, title="Colores: Valores de D",inset=.01,text.font=3)


