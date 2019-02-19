datos <- read.table(file = "resFixed.csv",header = TRUE,sep = "")
datos
plot(datos$L, datos$resultado,pch=4)
colors = rainbow(6)
i=1
for (value in unique(datos$D)){
  points(datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado,col=colors[i],bg=colors[i],pch=16)
  lines (datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado, type="l",col=colors[i])
  i=i+1
}

#plot(datos[datos$D==1, ]$L, datos[datos$D==1, ]$resultado)