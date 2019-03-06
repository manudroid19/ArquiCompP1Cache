#pdf('L3M-L3A.pdf',10,8)
par(mar=c(4,4,0,4)+0.1)
archivo="rf10.csv"
file.list <- list.files(path = ".", pattern="rPapi_PAPI_L2_TCM.csv", full.names=FALSE, recursive = TRUE)
#file.list<- append(file.list,list.files(path = ".", pattern="resSinMhz100.*.csv", full.names=TRUE, recursive = TRUE))
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))

#datos <- read.table(file = archivo,header = TRUE,sep = "")
datos=aggregate(.~L+D,datos1, median)

datos$resultado<-NULL
datos$fallo<-NULL
datos$R<-NULL
file.list <- list.files(path = ".", pattern="rPapi_PAPI_L2_TCA.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
file.list <- list.files(path = ".", pattern="rPapi_PAPI_L3_TCM.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
file.list <- list.files(path = ".", pattern="rPapi_PAPI_L3_TCA.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
file.list <- list.files(path = ".", pattern="rPapi_PAPI_LD_INS.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
file.list <- list.files(path = ".", pattern="rPapi_PAPI_SR_INS.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
file.list <- list.files(path = ".", pattern="rPapi_PAPI_L1_TCM.csv", full.names=FALSE, recursive = TRUE)
datos1 = do.call(rbind, lapply(file.list, function(x) read.table(x, header = TRUE,sep = "")))
datos1=aggregate(.~L+D,datos1, median)
datos=cbind(datos,datos1[5])
datos$resultado=1-datos$PAPI_L2_TCM/(datos$PAPI_L2_TCA)

#desviaciones=aggregate(.~L+D,datos1, sd)
#with(datos)
plot(datos$L, datos$resultado,col="white",xlab="Lineas cache (escala log)",main = "" ,xaxt="n",log="x",ylim=c(0,1),ylab="Fallos L3/Accesos L3")
axis(1,c(datos$L,c(512,4096)))
colors = rainbow(6)[c(1,3:6)]

i=1
for (value in unique(datos$D)){
  points(datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado,col=colors[i],pch=16)
  lines (datos[datos$D==value, ]$L,datos[datos$D==value, ]$resultado, type="l",lwd=3, col=colors[i])
  i=i+1
}
text(c(650,5500),c(21.8,21.8),c("S1=512","S2=4096"))
abline(v=c(512,4096), lty=c(2,2))
legend("topleft", legend=rev(paste("D =",unique(datos$D))),
       col=rev(colors), lty=1, cex=1, lwd=3, title="Colores: Valores de D",inset=.01,text.font=3)
#dev.off()