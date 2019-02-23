datos <- read.table(file = "res-mixed.csv",header = TRUE,sep = "")
erres <- read.table(file = "erres.txt",header = TRUE,sep = "")
erres
plot(datos$L, datos$resultado,col="white",xlab="Lineas cache (escala log)", ylab="Coste en ciclos por acceso",xaxt="n", log = "x")
axis(1,c(datos$L,c(512,4096)))
colors = rainbow(6)[c(1,3:6)]

i=1
for (value in unique(datos$D)){
  points(datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado,col=colors[i],pch=16)
  lines (datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado, type="l",lwd=3, col=colors[i])
  text(erres[erres$D==value, ]$L, datos[datos$D==value, ]$resultado+0.2, labels=erres[erres$D==value, ]$R, cex= 0.7)
  i=i+1
}
text(c(650,5500),c(21.8,21.8),c("S1=512","S2=4096"))
abline(v=c(512,4096), lty=c(2,2))
legend("bottom", legend=rev(paste("D =",unique(datos$D))),
       col=rev(colors), lty=1, cex=1, lwd=3, title="Colores: Valores de D",inset=.01,text.font=3)


