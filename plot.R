pdf('theFile.pdf',10,8)
par(mar=c(4,4,0,4)+0.1)
archivo="rf10.csv"
file.list <- list.files(path = ".", pattern="rf.*.csv", full.names=FALSE, recursive = TRUE)
file.list<- append(file.list,list.files(path = ".", pattern="resSinMhz100.*.csv", full.names=TRUE, recursive = TRUE))
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))

#datos <- read.table(file = archivo,header = TRUE,sep = "")
erres <- read.table(file = "erres.txt",header = TRUE,sep = "")
datos=aggregate(.~L+D,datos1, median)
desviaciones=aggregate(.~L+D,datos1, sd)
#with(datos)
plot(datos$L, datos$resultado,col="white",xlab="Lineas cache (escala log)",main = "" ,xaxt="n",log="x", ylim=c(8,31),ylab="Coste en ciclos por acceso")
axis(1,c(datos$L,c(512,4096)))
colors = rainbow(6)[c(1,3:6)]

i=1
for (d in unique(datos$D)){
  for (l in unique(datos$L)){
    boxplot(datos1[datos1$D==d&datos1$L==l,]$resultado,outline = FALSE,add = TRUE,at=l,whisklty = 0, staplelty = 0,boxwex=0.2*i,col= rgb(1.0,1.0,1.0,alpha=0))
  }
  i=i+1
}
i=1
for (value in unique(datos$D)){
  points(datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado,col=colors[i],pch=16)
  lines (datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado, type="l",lwd=3, col=colors[i])
  if("R" %in% colnames(datos))
  {
    #text(datos[datos$D==value, ]$L, datos[datos$D==value, ]$resultado+0.2, labels=datos[datos$D==value, ]$R, cex= 0.7)
  }else{
  text(erres[erres$D==value, ]$L, datos[datos$D==value, ]$resultado+0.2, labels=erres[erres$D==value, ]$R, cex= 0.7)
  }
  i=i+1
}
text(c(650,5500),c(21.8,21.8),c("S1=512","S2=4096"))
abline(v=c(512,4096), lty=c(2,2))
legend("topleft", legend=rev(paste("D =",unique(datos$D))),
       col=rev(colors), lty=1, cex=1, lwd=3, title="Colores: Valores de D",inset=.01,text.font=3)


#sd(datos1[datos1$D==5&datos1$L==256,]$resultado)
dev.off()