#To plot the distributions of H12 stats for different scenarios.

setwd("C:/Users/Parul Johri/Work/Projects/PlosgenViewPoint/PlosgenDroso/Statistics_final")
library("ggplot2", lib.loc="~/R/win-library/3.5")

par(mfcol=c(1,1))
par(mar=c(4,4,2,1))

#Duchen Model
t_duc_low <- read.table("slim_Duchen_neutral_const_rec_low_scaled300_ral_nogrowth_H12.stats", h=T)
t_duc_droso <- read.table("slim_Duchen_neutral_var_rec_droso_scaled300_ral_nogrowth_H12.stats", h=T)
t_duc_dfe_droso <- read.table("slim_Duchen_DFE_var_rec_droso_scaled300_ral_nogrowth_H12.stats", h=T)

d_data <- data.frame(cbind(t_duc_low$H12, t_duc_droso$H12, t_duc_dfe_droso$H12))
colnames(d_data) <- c("neu_const", "neu_var", "sel_var")

#plot the full distribution:
colors <- c("Neu const rec" = "turquoise2", "Neu var rec" = "deepskyblue3", "Sel var rec" = "dark blue")
g1 <- ggplot(d_data)+ theme_classic()+ labs(x="H12", y="Frequency", color = "") + coord_cartesian(xlim=c(min(c(t_duc_low$H12, t_duc_dfe_droso$H12)),0.15))
g2 <- g1 + geom_density(aes(x=neu_const, ..scaled.., color="Neu const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g4 <- g3 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g5 <- g4 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g5)

#cut it off at 0.05:
colors <- c("Neu const rec" = "turquoise2", "Neu var rec" = "deepskyblue3", "Sel var rec" = "dark blue")
g1 <- ggplot(d_data)+ theme_classic()+ labs(x="H12", y="Frequency", color = "") + coord_cartesian(xlim=c(min(c(t_duc_low$H12, t_duc_dfe_droso$H12)),0.05))
g2 <- g1 + geom_density(aes(x=neu_const, ..scaled.., color="Neu const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g4 <- g3 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g5 <- g4 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm')) 
plot(g5)

#Arguello Model:
#Read all files:
t_arg_low <- read.table("slim_Arguello_neutral_const_rec_low_scaled100_ith_nogrowth_H12.stats", h=T)
t_arg_droso <- read.table("slim_Arguello_neutral_var_rec_droso_scaled100_ith_nogrowth_H12.stats", h=T)
t_arg_dfe_droso <- read.table("slim_Arguello_DFE_var_rec_droso_scaled100_ith_nogrowth_H12.stats", h=T)

d_data <- data.frame(cbind(t_arg_low$H12, t_arg_droso$H12, t_arg_dfe_droso$H12))
colnames(d_data) <- c("neu_const", "neu_var", "sel_var")

#plot to 0.15:
colors <- c("Neu const rec" = "coral", "Neu var rec" = "firebrick1", "Sel var rec" = "darkred")
g1 <- ggplot(d_data)+ theme_classic()+ labs(x="H12", y="Frequency", color = "") + coord_cartesian(xlim=c(min(c(t_arg_low$H12, t_arg_dfe_droso$H12)),0.15))
g2 <- g1 + geom_density(aes(x=neu_const, ..scaled.., color="Neu const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g4 <- g3 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g5 <- g4 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g5)

#plot to 0.05:
colors <- c("Neu const rec" = "coral", "Neu var rec" = "firebrick1", "Sel var rec" = "darkred")
g1 <- ggplot(d_data)+ theme_classic()+ labs(x="H12", y="Frequency", color = "") + coord_cartesian(xlim=c(min(c(t_arg_low$H12, t_arg_dfe_droso$H12)),0.05))
g2 <- g1 + geom_density(aes(x=neu_const, ..scaled.., color="Neu const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g4 <- g3 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g5 <- g4 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g5)


