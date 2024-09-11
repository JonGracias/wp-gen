<?php get_header(); ?>        
<div id="content-wrapper">
            <div id="content">
				<?php if (have_posts()) : ?>
					<?php while (have_posts()) : the_post(); ?>
                <span class="date"><?php the_time('m.j.y') ?> <!-- by <?php the_author() ?> --></span><h3 class="post-title"><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title(); ?>"><?php the_title(); ?></a></h3>
                <p><?php the_content('Read the rest of this entry &raquo;'); ?></p>
  
<div class="commentbox"><?php the_tags('Tags: ', ', ', '<br />'); ?> | Posted in <?php the_category(', ') ?> | <?php edit_post_link('Edit', '', ' | '); ?>  <?php comments_popup_link('No Comments &#187;', '1 Comment &#187;', '% Comments &#187;'); ?></div>
							<?php endwhile; ?>
				
		<div class="navigation">
			<div class="alignleft"><?php next_posts_link('&laquo; Older Entries') ?></div>
			<div class="alignright"><?php previous_posts_link('Newer Entries &raquo;') ?></div>
		</div>


	<?php else : ?>

		<h2 class="center">Not Found</h2>
		<p class="center">Sorry, but you are looking for something that isn't here.</p>
		<?php include (TEMPLATEPATH . "/searchform.php"); ?>

	<?php endif; ?>
                
                
	
	


             </div>   
        </div>

<?php get_sidebar(); ?>		
<?php get_footer(); ?>	
