<?php get_header(); ?>       
<div id="post_content-wrapper">
            <div id="post_content">
				<?php if (have_posts()) : ?>
				<?php while (have_posts()) : the_post(); ?>
                <h3 class="post-title"><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title(); ?>"><?php the_title(); ?></a></h3>
                <p><?php the_content('Read the rest of this entry &raquo;'); ?></p>
  
<div class="commentbox"><?php the_tags('Tags: ', ', ', '<br />'); ?> | <?php the_time('F jS, Y') ?> <!-- by <?php the_author() ?> --> | Posted in <?php the_category(', ') ?> | <?php edit_post_link('Edit', '', ' | '); ?></div>
					<div id="comments"><?php comments_template(); ?></div>
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
		
<?php get_footer(); ?>	