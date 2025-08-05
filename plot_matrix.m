function plot_matrix(mat, label, condition, iSubj, f_range, path)
    figure;
    imagesc(mat);
    colorbar;
    title(sprintf('%s in range %.1f–%.1f Hz', label, f_range(1), f_range(2)));
    subtitle(sprintf('%s - Subject %d', condition, iSubj));
    xlabel('Electrode i'); ylabel('Electrode j');
    filename = sprintf('%s_subj%d_%s_%.1f_%.1f.jpg', ...
        strrep(label, ' ', ''), iSubj, condition, f_range(1), f_range(2));
    saveas(gcf, fullfile(path, filename));
    close;
end
