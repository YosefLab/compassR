# #' Title
# #' 
# #' Description
# #' 
# #' @param linear_gene_expression_matrix_file the first param
# #' 
# #' @return the output
# #' 
# #' @importFrom dplyr %>%
# #' 
# #' @noRd
# get_gene_expression_statistics <- function(linear_gene_expression_matrix_file) {
#     linear_gene_expression_matrix <-
#         read_compass_matrix(linear_gene_expression_matrix_file) %>%
#         dplyr::rename(gene = 1) %>%
#         tibble::column_to_rownames("gene") %>%
#         data.matrix()
#     total_expressions <- colSums(linear_gene_expression_matrix)
#     metabolic_expressions <- # TODO
#     gene_expression_statistics <- rbind(
#         total_expression = total_expressions,
#         metabolic_expression = metabolic_expressions,
#         metabolic_activity = metabolic_expressions / total_expressions
#     )
#     gene_expression_statistics
# }

# linear_scale_tpm <- # linear_gene_expression_matrix
# total_activity <- colSums(linear_scale_tpm)
# absolute_metabolic_activity <- colSums(
#     linear_scale_tpm[intersect(
#         rownames(linear_scale_tpm), RECON$gene_md$HGNC.symbol
#     ),])
# here RECON$gene_md$HGNC.symbol is the human RECON2 gene_symbol column, and if we're using the mouse RECON2 then we will use the mouse gene_symbol column in the gene metadata csv file.

# TODO: Can you get me a clean copy of RECON2, not your special home-brew, from which I can construct a RECON2_Homo_Sapien and a RECON2_Mus_Musculus? In mine the dimensions are totally messed up -- some rows have lots of columns, some have very few.
# There's actually RECON2 for humans and RECON2 for mice.
# for RECON2 for humans: same metabolite and reaction metadata. in gene metadata, rename "HGNC.symbol" to "gene_symbol", and delete the columns prefixed with MGI
# for RECON2 for mice: do the opposite ^
# make sure the N/A entries are loaded as NA in R

# TODO: [this is the "table on line 68"] End goal: a table with columns including ...
# all the columns from cell metadata
# total_expression
# metabolic_expression
# metabolic_activity
# TODO: Actually, in accordance with proper database style, cell_metadata should be a table and there should also be a table whose rows are the cell ids and whose cols are total_expression, metabolic_expression, and metabolic_activity. If you want to join them, you can, and we'll have examples showing how.

# TODO: So basically we somehow provide the user a way to get some things:
# One is the matrix reaction_consistencies (after log2 and sweeping out col means).
# One is the matrix meta_rxn_consistency, which is computed from reaction_consistencies.
# One is the table from line 68.

# TODO: Then we also make examples that show them how to ...
# Add rows from reaction_consistencies (or meta_rxn_consistency) to the table from line 68.
# Make a UMAP
#   (1) Compute the UMAP embedding based on either reaction_consistencies or meta_rxn_consistency
#   (2) Plot the UMAP, coloring it by a column in the table from line 68, or a row from reaction_consistencies or meta_rxn_consistency

# TODO: We don't need our own UMAP-drawing function. The user can do it. Just include examples.

# mat <- metareaction_consistencies # aka meta_rxn_consistency
# library(uwot)
# res_umap <- uwot::umap(t(mat), scale = "none")
# anno <-
#     tibble(DepMap_ID = colnames(mat), UMAP1 = res_umap[,1], UMAP2 = res_umap[,2]) %>% # DepmapID is specific to our data; call it cell_id instead.
#     inner_join(sample_md, by = "DepMap_ID") %>% # TODO: What is sample_md? it is the cell metadata, ie Th17 # TODO: this is an inner join. maybe think about producing a warning for dropped rows # TODO: Again, we already have these cols (see todo on line 68)
#     left_join(
#         enframe(total_activity, "DepMap_ID", "total_activity"), # now total_expression
#         by =  "DepMap_ID"
#     ) %>%
#     left_join(
#         enframe(metabolic_activity, "DepMap_ID", "metabolic_activity"), # now metabolic_expression
#         by =  "DepMap_ID"
#     ) %>%
#     mutate(metabolic_activity_ratio = metabolic_activity / total_activity) %>% # now metabolic_activity
#     # TODO: These lines ^ basically add in total_expression, metabolic_expression, and metabolic_activity so that the user can color the plot according to any of those metrics. but we will have these columns already in our table (see todo on line 68)



# metareactions <- compassanalytics::get_metareactions(reaction_consistencies)
# annotated_reactions <- compassanalytics::get_annotated_reactions(reaction_consistencies, "_", c("pos", "neg"))

# TODO: annotations should be optional

# TODO: It seems to me that compass_rxn_df is never actually needed? We use it to get meta_rxn_consistency, but only the columns reaction_id (aka rxn_code) and metareaction_id (aka meta_rxn). The columns unannotated_reaction (aka rxn_code_no_direction) and annotation (aka direction) seem totally useless.
# compass_rxn_df <- # join metareactions with annotated_reactions to get a tibble with columns:
# #     reaction_id (aka rxn_code),
# #     metareaction_id (aka meta_rxn),
# #     unannotated_reaction (aka rxn_code_no_direction),
# #     annotation (aka direction)
# compass_rxn_df %<>%
#     left_join(
#         as_tibble(rxn_df), # rxn_df is loaded from RECON2/reaction_metadata.csv
#         by = c("unannotated_reaction" = "rxn_code_nodirection") # The reaction metadata always includes a "rxn_code_nodirection" column, or you know, a column with the same purpose but possibly a different name. Btw rxn_df contains a superset of rxns so do a left join.
#     )

# TODO: Is this ever used ... ?

# #' Title
# #' 
# #' Description
# #' 
# #' @param reaction_consistencies the first param
# #' 
# #' @return the output
# #' 
# #' @importFrom magrittr %>% %<>%
# #' 
# #' @noRd
# get_annotated_reactions <- function(reaction_consistencies, separator, annotations) {
#     # Assumes reaction_id of the form {unique reaction id}{separator}{one of several annotations}.
#     reaction_ids <- rownames(reaction_consistencies)
#     patterns <- stringr::str_glue("^(.+){separator}({annotation})$", separator = separator,annotation = annotations)
#     annotated_reactions <- matrix(nrow = 0, ncol = 3)
#     for (pattern in patterns) {
#         annotated_reactions %<>% rbind(na.omit(stringr::str_match(reaction_ids, pattern)))
#     }
#     colnames(annotated_reactions) <- c(
#         "reaction_id",
#         "unannotated_reaction",
#         "annotation"
#     )
#     annotated_reactions %<>% tibble::as_tibble()
#     annotated_reactions
# }
