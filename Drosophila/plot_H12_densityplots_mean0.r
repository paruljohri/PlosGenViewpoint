#To plot the distributions of H12 stats for different scenarios.
#Using boxplots.

setwd("C:/Users/Parul Johri/Work/Projects/PlosgenViewPoint/PlosgenDroso/Statistics/")
library("ggplot2", lib.loc="~/R/win-library/3.5")


#Duchen Model
t_duc_low <- read.table("Duchen_const_rec_low_stats/Duchen_const_rec_low_H12.stats", h=T)
t_duc_droso <- read.table("Duchen_var_rec_droso_stats/Duchen_var_rec_droso_H12.stats", h=T)
t_duc_dfe_droso <- read.table("Duchen_DFE_var_rec_droso_stats/Duchen_DFE_var_rec_droso_H12.stats", h=T)
s_mean_low <- mean(t_duc_low$H12)
s_mean_droso <- mean(t_duc_droso$H12)
s_mean_dfe_droso <- mean(t_duc_dfe_droso$H12)
v_neu_const <- t_duc_low$H12-s_mean_low
v_neu_var <- t_duc_droso$H12-s_mean_droso
v_sel_var <- t_duc_dfe_droso$H12-s_mean_dfe_droso
xname=expression(paste("H12", "-", bar("H12")))
#plot:
colors <- c("Neu const rec" = "turquoise2", "Neu var rec" = "deepskyblue3", "Sel var rec" = "dark blue")
g1 <- ggplot()+ theme_classic()+ labs(x=xname, y="Frequency", color = "")
g2 <- g1 + geom_density(aes(x=v_neu_const, ..scaled.., color="Neu const rec"), lwd=1.2) #+ coord_cartesian(xlim=c(-0.04,0.2))
g3 <- g2 + geom_density(aes(x=v_neu_var, ..scaled.., color="Neu var rec"), lwd=1.2)
g4 <- g3 + geom_density(aes(x=v_sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g5 <- g4 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g6 <- g5 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g6)

#Arguello Model:
#Read all files:
t_arg_low <- read.table("Arguello_const_rec_low_stats/Arguello_const_rec_low_H12.stats", h=T)
t_arg_droso <- read.table("Arguello_var_rec_droso_stats/Arguello_var_rec_droso_H12.stats", h=T)
t_arg_dfe_droso <- read.table("Arguello_DFE_var_rec_droso_stats/Arguello_DFE_var_rec_droso_H12.stats", h=T)
s_mean_low <- mean(t_arg_low$H12)
s_mean_droso <- mean(t_arg_droso$H12)
s_mean_dfe_droso <- mean(t_arg_dfe_droso$H12)
v_neu_const <- t_arg_low$H12-s_mean_low
v_neu_var <- t_arg_droso$H12-s_mean_droso
v_sel_var <- t_arg_dfe_droso$H12-s_mean_dfe_droso
xname=expression(paste("H12", "-", bar("H12")))
#plot:
colors <- c("Neu const rec" = "coral", "Neu var rec" = "firebrick1", "Sel var rec" = "darkred")
g1 <- ggplot()+ theme_classic()+ labs(x=xname, y="Frequency", color = "")
g2 <- g1 + geom_density(aes(x=v_neu_const, ..scaled.., color="Neu const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=v_neu_var, ..scaled.., color="Neu var rec"), lwd=1.2)
g4 <- g3 + geom_density(aes(x=v_sel_var, ..scaled.., color="Sel var rec"),  lwd=1.2)
g5 <- g4 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g6 <- g5 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g6)

#Comparison between the two slim models:
t_duc_dfe_low <- read.table("Duchen_DFE_const_rec_low_stats/Duchen_DFE_const_rec_low_H12.stats", h=T)
t_duc_dfe_droso <- read.table("Duchen_DFE_var_rec_droso_stats/Duchen_DFE_var_rec_droso_H12.stats", h=T)
d_data <- data.frame(cbind(t_duc_dfe_low$H12, t_duc_dfe_droso$H12))
colnames(d_data) <- c("sel_const", "sel_var")
colors <- c("Selection const rec" = "skyblue", "Selection var rec" = "dark blue")
g1 <- ggplot(d_data)+ theme_classic()+ labs(x="H12", y="Frequency", color = "")
g2 <- g1 + geom_density(aes(x=sel_const, ..scaled.., color="Selection const rec"), lwd=1.2)
g3 <- g2 + geom_density(aes(x=sel_var, ..scaled.., color="Selection var rec"),  lwd=1.2)
g4 <- g3 + theme(axis.text.x=element_text(size=15),axis.text.y=element_text(size=15),axis.title.x=element_text(size=20),axis.title.y=element_text(size=20)) 
g5 <- g4 + scale_color_manual(values = colors) + theme(legend.text=element_text(size=15), legend.position="right", legend.spacing.x = unit(1.0, 'cm'))
plot(g5)
