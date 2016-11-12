library(Momocs)
rm(list=ls())

# from Coo to coo
to_coo <- function(x)
  UseMethod("to_coo")

to_coo.data.frame <- function(x){
  x %>%
    apply(1, function(.) paste(names(.), as.character(.))) %>%
    as.character()
}

# to_coo(iris[1:5, ])
# to_coo(iris[1,, drop=FALSE])

to_coo.matrix <- function(x)
  x %>% apply(1, paste, collapse=" ")
#' bot[1] %>% coo_sample(8) %>% to_coo

to_coo.Coo <- function(x){
  f <- function(x) c(x$fac %>% to_coo, x$coo[[1]] %>% to_coo)
  n <- paste0(names(x), ".coo")
  for (i in seq(length(x)))
    x %>% slice(i) %>% f() %>% write(file=n[i])
}
bot %>% to_coo()
# bot %>% slice(1) %>% to_coo()

read_coo <- function(file){
  x <- readLines(file)
  cov0 <- x %>%
    grep("^[[:alpha:]]+ [[:alnum:]]+$", ., value=TRUE) %>%
    strsplit(" ") %>% do.call("rbind", .) %>% t
  cov <- cov0[-1,, drop=FALSE] %>% data.frame()
  colnames(cov) <- cov0[1, ]

  p_ids <-  grep("^[[:alpha:]]+[[:alnum:]]*$", x)
  if (length(p_ids) <= 1){
    coo_lines <- x %>%
      grep("^[[:digit:]]+ [[:digit:]]+", ., value=TRUE)
    coo     <- coo_lines %>%
      strsplit(" ") %>% lapply(as.numeric) %>%
      do.call("rbind", .)
  } else {
    p <-  x %>% grep("^[[:digit:]]+ [[:digit:]]+", .)
    dp <- diff(p)
    begs <- c(1, p[which(dp!=1)+1])
    ends <- c(p[which(dp!=1)], tail(p, 1))
    coo <- vector("list", 3)
    for (i in seq_along(begs)){
      coo[[i]] <- coo_lines %>%
        `[`(begs[i]:ends[i]) %>%
        strsplit(" ") %>% lapply(as.numeric) %>%
        do.call("rbind", .)
    }
  }
  list(cov=cov, coo=coo)
}

b1 <- bot %>% slice(1)
b1 %>% to_coo() %>% write(file="coo_1sttry.coo")
read_coo("coo_1sttry.coo")
file.remove("coo_1sttry.coo")

library("microbenchmark")
microbenchmark(b1 %>% to_coo()) #1.4 ms
microbenchmark(b1 %>% to_coo() %>% write(file="coo_1sttry.coo")) #2.5 ms
microbenchmark(read_coo("coo_1sttry.coo")) # 1.5 ms

