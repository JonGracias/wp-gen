<?php get_header(); ?>

<div id="home-banner">
    <img src="<?php echo get_avatar_url(get_current_user_id()); ?>" alt="Profile Picture" id="profile-picture">
    <div id="home-banner-content">
        <h1 class="blog-title">
            Hello, I'm Jonatan Gracias
        </h1>
        <p class="tagline">
            Welcome to my website! I'm a freelance web developer with a passion for creating beautiful, functional, and user-friendly designs. Let's build something great together.
        </p>
    </div>
</div>


<div id="separator">My Projects</div>

<div id="home-content-wrapper">
    <div id="content">
        <?php if (have_posts()) : ?>
            <?php while (have_posts()) : the_post(); ?>
                <span class="date"><?php the_time('m.j.y') ?> <!-- by <?php the_author() ?> --></span>
                <h3 class="post-title">
                    <a href="<?php the_permalink(); ?>" rel="bookmark" title="Permanent Link to <?php the_title(); ?>">
                        <?php the_title(); ?>
                    </a>
                </h3>
                <p><?php the_content('Read the rest of this entry &raquo;'); ?></p>

                <div class="commentbox">
                    <?php the_tags('Tags: ', ', ', '<br />'); ?> |
                    Posted in <?php the_category(', '); ?> |
                    <?php edit_post_link('Edit', '', ' | '); ?>
                    <?php comments_popup_link('No Comments &#187;', '1 Comment &#187;', '% Comments &#187;'); ?>
                </div>
            <?php endwhile; ?>

            <div class="navigation">
                <div class="alignleft"><?php next_posts_link('&laquo; Older Entries'); ?></div>
                <div class="alignright"><?php previous_posts_link('Newer Entries &raquo;'); ?></div>
            </div>
        <?php else : ?>
            <h2 class="center">Nothing Yet!</h2>
            <p class="center">Check back later for more posts.</p>
        <?php endif; ?>
    </div>
</div>

<?php get_footer(); ?>
