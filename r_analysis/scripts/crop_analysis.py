import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

try:
    import seaborn as sns
    has_seaborn = True
except ImportError:
    has_seaborn = False

def main():
    print("==============================================================")
    print("  SmartAgri Crop Data Science Engine — Compiling Statistics   ")
    print("==============================================================")

    # 1. Paths Setup
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    data_path = os.path.join(base_dir, "data", "crop", "crop_recommendation.csv")
    output_dir = os.path.join(base_dir, "r_analysis", "output")
    os.makedirs(output_dir, exist_ok=True)

    print(f"Loading dataset: {data_path}")
    if not os.path.exists(data_path):
        print(f"Error: Dataset not found at {data_path}")
        return

    df = pd.read_csv(data_path)
    numeric_cols = ['N', 'P', 'K', 'temperature', 'humidity', 'moisture', 'ph', 'rainfall']
    
    # ==============================================================
    # Phase 1: Summary Statistics
    # ==============================================================
    print("Phase 1: Calculating descriptive summary statistics...")
    
    crop_stats = df.groupby('crop')[numeric_cols].agg(['mean', 'std']).round(2)
    
    # Flatten columns
    crop_stats.columns = [f"{col}_{metric}" for col, metric in crop_stats.columns]
    
    stats_csv_path = os.path.join(output_dir, "08_crop_summary_statistics.csv")
    crop_stats.to_csv(stats_csv_path)
    print(f"Saved summary statistics spreadsheet to: {stats_csv_path}")

    # ==============================================================
    # Phase 2: Feature Correlation Heatmap
    # ==============================================================
    print("Phase 2: Compiling correlation matrix heatmap...")
    corr_matrix = df[numeric_cols].corr()

    plt.figure(figsize=(10, 8))
    
    if has_seaborn:
        mask = np.triu(np.ones_like(corr_matrix, dtype=bool))
        sns.heatmap(
            corr_matrix,
            mask=mask,
            cmap="RdYlGn",
            vmax=1.0,
            vmin=-1.0,
            center=0,
            square=True,
            linewidths=.5,
            annot=True,
            cbar_kws={"shrink": .8}
        )
    else:
        # Standard matplotlib fallback if seaborn is not fully linked
        plt.imshow(corr_matrix, cmap="RdYlGn", interpolation="nearest")
        plt.colorbar()
        plt.xticks(range(len(numeric_cols)), numeric_cols, rotation=45)
        plt.yticks(range(len(numeric_cols)), numeric_cols)
        # Add labels
        for i in range(len(numeric_cols)):
            for j in range(len(numeric_cols)):
                plt.text(j, i, f"{corr_matrix.iloc[i, j]:.2f}", ha="center", va="center", color="black")

    plt.title("Crop Requirements — Overall Feature Correlation Map", fontsize=14, fontweight='bold', pad=15)
    plt.tight_layout()
    
    heatmap_path = os.path.join(output_dir, "09_overall_feature_correlation.png")
    plt.savefig(heatmap_path, dpi=150)
    plt.close()
    print(f"Saved feature correlation map to: {heatmap_path}")

    # ==============================================================
    # Phase 3: Pair Plotting / Decision Clusters
    # ==============================================================
    print("Phase 3: Drawing decision boundaries and pair plots...")
    
    # We filter down to key crops to make the visual plots readable
    subset_crops = ["Rice", "Maize", "Tomato", "Apple", "Watermelon", "Potato"]
    df_subset = df[df['crop'].isin(subset_crops)]

    # Set default plotting parameters for massive, clear labels
    plt.rcParams.update({
        'font.size': 18,
        'axes.labelsize': 20,
        'axes.titlesize': 20,
        'xtick.labelsize': 14,
        'ytick.labelsize': 14,
        'legend.fontsize': 18
    })

    if has_seaborn:
        sns.set_theme(style="ticks", rc={
            'font.size': 18,
            'axes.labelsize': 20,
            'axes.titlesize': 20,
            'xtick.labelsize': 14,
            'ytick.labelsize': 14,
        })
        g = sns.pairplot(
            df_subset,
            vars=['N', 'K', 'ph', 'temperature', 'rainfall'],
            hue='crop',
            palette="Set2",
            diag_kind="kde",
            plot_kws={'alpha': 0.8, 's': 150, 'edgecolor': 'k', 'linewidth': 0.5},
            height=4.5,
        )
        g.fig.suptitle("Crop Requirement Pairwise Clusters & Decision Boundaries", y=1.03, fontsize=26, fontweight='bold')
        # Format the legend beautifully and move it further right
        plt.setp(g._legend.get_title(), fontsize=20, fontweight='bold')
        plt.setp(g._legend.get_texts(), fontsize=18)
        g._legend.set_bbox_to_anchor((1.06, 0.5))
        
        pairplot_path = os.path.join(output_dir, "11_crop_pairplot.png")
        g.savefig(pairplot_path, dpi=300, bbox_inches='tight')
        plt.close()
    else:
        # Custom matplotlib subplot grid fallback - Ultra premium dark-theme aligned styling
        fig, axes = plt.subplots(3, 3, figsize=(18, 16))
        plot_vars = ['N', 'K', 'ph']
        colors = {
            'Rice': '#3B82F6',       # Sleek Blue
            'Maize': '#F59E0B',      # Vibrant Amber
            'Tomato': '#EF4444',     # Deep Red
            'Apple': '#10B981',      # Premium Emerald
            'Watermelon': '#06B6D4', # Cyber Cyan
            'Potato': '#8B5CF6'      # Royal Purple
        }
        
        for i in range(3):
            for j in range(3):
                ax = axes[i, j]
                var_x = plot_vars[j]
                var_y = plot_vars[i]
                
                # Make gridlines clean
                ax.grid(True, linestyle='--', alpha=0.3, color='#CBD5E1')
                ax.set_facecolor('#F8FAFC') # Soft off-white plot area background
                
                # Thick spines
                for spine in ax.spines.values():
                    spine.set_color('#94A3B8')
                    spine.set_linewidth(1.5)
                
                ax.tick_params(axis='both', which='major', labelsize=14, colors='#475569')
                
                if i == j:
                    # Diagonal - histogram
                    for crop_name, color in colors.items():
                        crop_df = df_subset[df_subset['crop'] == crop_name]
                        ax.hist(crop_df[var_x], alpha=0.45, color=color, label=crop_name, bins=12, edgecolor=color, linewidth=1)
                    ax.set_title(f"{var_x} Distribution", fontsize=18, fontweight='bold', pad=12, color='#0F172A')
                else:
                    # Scatter plot with large, distinct circular points and clean black borders
                    for crop_name, color in colors.items():
                        crop_df = df_subset[df_subset['crop'] == crop_name]
                        ax.scatter(
                            crop_df[var_x], 
                            crop_df[var_y], 
                            alpha=0.8, 
                            color=color, 
                            s=180, 
                            edgecolor='black', 
                            linewidth=0.6, 
                            label=crop_name
                        )
                
                if i == 2:
                    ax.set_xlabel(var_x, fontsize=18, fontweight='bold', labelpad=10, color='#0F172A')
                if j == 0:
                    ax.set_ylabel(var_y, fontsize=18, fontweight='bold', labelpad=10, color='#0F172A')
                    
        # Get legend handles from a scatter plot cell to show circles instead of histogram blocks
        handles, labels = axes[0, 1].get_legend_handles_labels()
        # Filter duplicates (since multiple scatter calls add identical labels)
        by_label = dict(zip(labels, handles))
        
        # Add legend completely outside the grid on the right-hand side
        leg = fig.legend(
            by_label.values(),
            by_label.keys(),
            loc='center left',
            bbox_to_anchor=(0.85, 0.5),
            fontsize=18,
            title="Crop Families",
            title_fontsize=20,
            frameon=True,
            facecolor='#FFFFFF',
            edgecolor='#E2E8F0',
            shadow=False,
        )
        leg.get_title().set_weight('bold')
        for handle in leg.legend_handles:
            handle.set_sizes([250]) # Massive dots inside the legend
            
        fig.suptitle("Crop Clusters — Scatter Matrix Grid (AI Decision Map)", fontsize=26, fontweight='bold', y=0.96, color='#0F172A')
        
        # Pull subplots to the left to make concrete room for the legend on the right side
        plt.subplots_adjust(right=0.82, left=0.08, bottom=0.08, top=0.88, wspace=0.35, hspace=0.35)
        
        pairplot_path = os.path.join(output_dir, "11_crop_pairplot.png")
        plt.savefig(pairplot_path, dpi=300, bbox_inches='tight')
        plt.close()

    print(f"Saved pair plot chart to: {pairplot_path}")
    print("\n==============================================================")
    print("  Crop Analysis Suite Execution Successfully Completed!      ")
    print("==============================================================")

if __name__ == "__main__":
    main()
