#single stacked bar plot of STEM majors versus non

dat %>% 
  #select course of interest only
  filter(crs_name == course_of_interest) |>
  #add n for all students in course
  add_tally(name = "n_course") %>%
  group_by(stem_major) %>% 
  #count sample size by each group, then divide by course total
  summarise(n_total = n(),
            n_course = mean(n_course)) %>%
  #create a dummy column for x axis, which will be hidden
  mutate(dummy = "dummy") %>%
  ggplot(aes(fill=as.factor(stem_major), y=n_total/n_course*100, x=dummy)) + 
  #plot bars in single bar
  geom_col() + 
  #add labels with percents
  geom_text(aes(label = round(n_total/n_course*100,0)),
            position = position_stack(vjust = 0.5)) +
  labs(x = NULL, y = "Percent(%)", fill = "STEM Major") + 
  theme_minimal() + 
  #hide x axis ticks
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

# if you want to add date range directly to plot captions
labs(caption = paste("Date range:", min(dat$crs_year), "-", max(dat$crs_year)))


#plot - using facets - majority and minority groups over time
dat %>%
  #filter course of interest
  filter(crs_name == course_of_interest) %>%
  #create a true "PEER" variable that compares PEER to white/Asian combined
  mutate(peer = ifelse(ethniccode_cat == 1, 1, 0)) %>%
  #create a semq text label for more clear x axis labels 
  mutate(semq_text = recode(as.character(crs_semq), "1" = "W", "2" = "Sp", "3" = "SuI", "4" = "SuII", "5" = "F")) %>%
  #create a crs_section variable to maintain x axis chronological ordering
  mutate(crs_section = paste0(crs_year, crs_semq)) %>%
  #create course label that orders readable labels create above chronologically
  mutate(crs_label = forcats::fct_reorder(as.factor(paste0(semq_text, crs_year)), as.integer(crs_section))) %>%
  #pivot to a long format dataframe
  pivot_longer(cols = c(peer, female, firstgen, lowincomeflag, international, transfer, stem_major), 
               names_to = "demo_var",
               values_to = "value")  %>%
  #calculate sample size for each group
  add_count(demo_var, value, name = "n") %>%
  #create a color code grouping based on demographic variable, with color for minoritized groups only
  mutate(color_code = ifelse(value == 0, "majority", demo_var)) %>%
  #rename labels to be more interpretable
  mutate(demo_var = factor(demo_var, 
                           levels = c("peer","female","firstgen","lowincomeflag","international","transfer", "stem_major"),
                           labels = c("PEER", "Woman", "FirstGen", "LowIncome", "International", "Transfer", "STEM Major"))) %>%

  #remove missing demographic variables before plotting
  drop_na(demo_var) %>%
  #PLOT 
  ggplot(aes(x = crs_label, y = numgrade, color = color_code, shape = as.factor(value))) + 
  #mean +/- 95% CI errorbars
  stat_summary(fun.data = "mean_cl_normal") + 
  #lines that connect each group over time
  stat_summary(geom = "line", fun.data = "mean_cl_normal", aes(group = interaction(demo_var, value))) + 
  labs(x = "Course Term", y = "Course grade",
       color = "Student identity", shape = NULL) + 
  #optional: separate plots for each demographic variable (note: plot very messy w/o this)
  facet_wrap(~demo_var) + 
  #use seismic color palette
  scale_color_manual(values = c("majority" = "gray",
                                "peer" = "#eb7e36", "female" = "#4671c6", "firstgen" = "#70ac49", "lowincomeflag" = "black", "international" = "#ffbe07", "transfer" = "#429dda", "stem_major" = "#B35050")) + 
  #make shape legend more interpretable
  scale_shape_discrete(name = "Student holds identity?", labels = c("0" = "no", "1" = "yes")) + 
  theme_seismic + 
  theme(axis.text.x = element_text(angle = 90)) + 
  # reposition legend to bottom
  theme(legend.position =  "bottom") + 
  #hide redundant color label
  guides(color = "none")


#editing HR code for heatmap


gpaogradeTally<-dat%>% 
  mutate(gpaobin=.1*floor(10*gpao)) %>%
  select(numgrade,gpaobin) %>% na.omit() %>% 
  group_by(numgrade,gpaobin)%>% tally()

yticks<-c(0,1,2,3,4)

gpaolevels<-as.character(seq(0,4.,.1))
gradelevels<-c("0","0.7","1","1.3","1.7", "2","2.3", "2.7" ,"3" ,  "3.3", "3.7" ,"4")

gpaogradeTally$numgrade<-ordered(as.factor(gpaogradeTally$numgrade),levels=gradelevels)
gpaogradeTally$gpaobin<-ordered(as.factor(gpaogradeTally$gpaobin),levels=gpaolevels)

glab<-c("F","D","C","B","A")


p<-ggplot(gpaogradeTally, aes(gpaobin, numgrade)) + 
  geom_tile(aes(fill = n), colour = "grey90") + 
  scale_y_discrete(breaks=yticks,labels=glab)+
  scale_x_discrete(breaks=yticks,labels=glab)+
  geom_segment(mapping=aes(x="0",y="0",xend="4",yend="4"),color="black",linewidth=1) +
  scale_fill_viridis() + 
  theme_seismic 


scale_fill_gradientn(colours = rev(gradient_pal),values=c(0,1),trans="sqrt")+
  # scale_fill_gradient2(low = "white",mid=UMICHprimary[2],high =UMICHprimary[1],trans = "log10",values=c(0,1,10))+
  #scale_fill_gradient(low = "white",high =UMICHprimary[1],trans = "log10")+
  ylab("Course Grade")+
  xlab("Grade Point Average (all other courses)")+
  ggtitle("Course Grade vs. GPAO")+
  geom_segment(mapping=aes(x="0",y="0",xend="4",yend="4"),color="black",size=1)+
  theme_bw() %+replace%
  theme(legend.text=element_text(size=12),
        aspect.ratio = 0.6)
print(p) 
#ggsave("page15-heatmap.jpg",width=6.5,height=5.25,dpi=150,units="in")  

